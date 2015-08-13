class profiles::puppet::master (
    $hiera_eyaml                  = true,
    $autosign_ensure              = absent,
    $policy_based_autosign_ensure = hiera("profiles::puppet::master::policy_based_autosign_ensure", absent),
    $autosign_script              = $profiles::puppet::params::autosign_script,
    $autosign_secret              = hiera("profiles::puppet::master::autosign_secret", false),
    $proxy                        = hiera("profiles::puppet::proxy", false),
    $sysconf_puppetserver         = $::profiles::puppet::params::sysconf_puppetserver,
    $data_binding_terminus        = hiera("profiles::puppet::master::data_binding_terminus", "none"),
#    $deploy_pub_key      = "",
#    $deploy_private_key  = "",
    $environmentpath              = $::profiles::puppet::params::environmentpath,
    $puppetconf                   = $::profiles::puppet::params::puppetconf,
) inherits profiles::puppet::params {

  validate_bool($hiera_eyaml)
  if ($autosign_script) {
    validate_absolute_path($autosign_script)
  }
  if $autosign_ensure == present and $policy_based_autosign_ensure == present {
    fail("Only one of autosign_ensure or policy_based_autosign_ensure can be set in profiles::puppet::master")
  }

  File {
    owner => "root",
    group => "root",
  }

  if $hiera_eyaml {
    $backends = [ "eyaml" ]
  } else {
    $backends = [ "hiera" ]
  }

  class { "hiera":
    hierarchy => [
      "nodes/%{clientcert}",
      "app_tier/%{app_tier}",
      "env/%{environment}",
      "common",
    ],
    datadir         => $profiles::puppet::params::hieradir,
    backends        => $backends,
    eyaml           => $hiera_eyaml,
    owner           => "pe-puppet",
    group           => "pe-puppet",
    provider        => "pe_puppetserver_gem",
    eyaml_extension => "yaml",
    notify          => Service["pe-puppetserver"],
  }

  include profiles::puppet::policy_based_autosign

  file { "autosign":
    ensure  => $autosign_ensure,
    content => "*",
    path    => "${::settings::confdir}/autosign.conf",
    notify  => Service["pe-puppetserver"]
  }

  file { $sysconf_puppetserver:
    ensure => file,
    owner  => "root",
    group  => "root",
    mode   => "0644",
  }

  # git revision in catalogue
  file { "/usr/local/bin/puppet_git_revision.sh":
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => "0755",
    content => template("${module_name}/puppet_git_revision.sh.erb"),
  }

  # data binding terminus explicit
  ini_setting { "puppet.conf data_binding_terminus":
    ensure  => present,
    setting => "data_binding_terminus",
    value   => $data_binding_terminus,
    section => "master", 
    path    => $puppetconf,
    notify  => Service["pe-puppetserver"],
  }

  #
  # Proxy server monkey patching
  #
  if $proxy {
    $regexp = 'https?://(.*?@)?([^:]+):(\d+)'
    $proxy_host = regsubst($proxy, $regexp, '\2')
    $proxy_port = regsubst($proxy, $regexp, '\3')
  }
  $proxy_ensure = $proxy ? {
    /.*/    => present,
    default => absent,
  }

  $http_proxy_var = "${sysconf_prefix}http_proxy=${proxy}"
  $https_proxy_var = "${sysconf_prefix}https_proxy=${proxy}"

  Ini_setting {
    ensure => $proxy_ensure,
  }

  # PMT (puppet.conf)
  ini_setting { "pmt proxy host":
    path     => $puppetconf,
    section  => "user",
    setting  => "http_proxy_host",
    value    => $proxy_host,
  }

  ini_setting { "pmt proxy port":
    path    => $puppetconf,
    section => "user",
    setting => "http_proxy_port",
    value   => $proxy_port,
  }

  # Enable pe-puppetserver to work with proxy
  file_line { "pe-puppetserver http_proxy":
    ensure => $proxy_ensure,
    path   => $sysconf_puppetserver,
    line   => $http_proxy_var,
    match  => "^${sysconf_prefix}http_proxy=",    
    notify => [ Service["pe-puppetserver"],
                Exec["systemctl_daemon_reload"] ],
  }

  file_line { "pe-puppetserver https_proxy":
    ensure => $proxy_ensure,
    path   => $sysconf_puppetserver,
    line   => $https_proxy_var,
    match  => "^${sysconf_prefix}https_proxy=",
    notify => [ Service["pe-puppetserver"],
                Exec["systemctl_daemon_reload"] ],
  }

  class { "profiles::puppet::agent":
    proxy => $proxy,
  }


  # patch the puppetserver gem command
  if $pe_server_version == "2015.2.0" {
    $file_to_patch = "/opt/puppetlabs/server/apps/puppetserver/cli/apps/gem"
    $patch_pe_gem = true
  } elsif $puppetversion =~ /3.8.* \(Puppet Enterprise/ {
    $file_to_patch = "/opt/puppet/share/puppetserver/cli/apps/gem"
    $patch_pe_gem = true
  } else {
    notify { "this version of Puppet Enterprise might not need puppetserver gem to be patched, please check for a newer version of this module at https://github.com/GeoffWilliams/r10k-control/ and raise an issue if there isn't one": }
    $patch_pe_gem = false
  }
  $line = "-Dhttps.proxyHost=${proxy_host} -Dhttp.proxyHost=${proxy_host} -Dhttp.proxyPort=${proxy_port} -Dhttps.proxyPort=${proxy_port} \\"

  if $patch_pe_gem {
    file_line { "gem http_proxy":
      ensure => $proxy_ensure,
      path   => $file_to_patch,
      match  => "^-Dhttps.proxyHost=",
      after  => "puppet-server-release.jar",
      line   => $line,
    }
  }
}
