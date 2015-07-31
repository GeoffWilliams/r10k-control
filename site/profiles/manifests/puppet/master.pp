class profiles::puppet::master (
    $hiera_eyaml = true,
    $autosign = false,
    $proxy = hiera("profiles::puppet::master::proxy", false),
    $sysconf_puppet = $::profiles::puppet::params::sysconf_puppet,
    $sysconf_puppetserver = $::profiles::puppet::params::sysconf_puppetserver,
    $puppet_agent_service = $::profiles::puppet::params::puppet_agent_service,
#    $deploy_pub_key = "",
#    $deploy_private_key = "",
#    $environmentpath = $::profiles::puppet::params::environmentpath,
) inherits profiles::puppet::params {
  validate_bool($hiera_eyaml,$autosign)

  File {
    owner => "root",
    group => "root",
  }

  class { "hiera":
    hierarchy => [
      "nodes/%{clientcert}",
      "app_tier/%{app_tier}",
      "env/%{environment}",
      "common",
    ],
    datadir   => $profiles::puppet::params::hieradir,
    backends  => $backends,
    eyaml     => $hiera_eyaml,
    owner     => "pe-puppet",
    group     => "pe-puppet",
    provider  => "pe_puppetserver_gem",
    notify    => Service["pe-puppetserver"],
  }

  if $autosign {
    file { "autosign":
      ensure  => "present",
      content => "*",
      path    => "${::settings::confdir}/autosign.conf",
    }
  }

  # puppet service force startup on 2015.2.0
  if $pe_server_version == "2015.2.0" {
    service { "puppet":
      ensure => running,
      enable => true,
    }
  }


  #
  # Proxy server monkey patching
  #
  $proxy_ensure = $proxy ? {
    /.*/    => present,
    default => absent,
  }

  $proxy_bash = "export http_proxy=${proxy} https_proxy=${proxy}"

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
  file_line { "pe-puppetserver proxy":
    ensure => $proxy_ensure,
    path   => $sysconf_puppetserver,
    line   => $proxy_bash,    
    notify => Service["pe-puppetserver"],
  }

  file_line { "puppet agent proxy":
    ensure => $proxy_ensure,
    path   => $sysconf_puppet,
    line   => $proxy_bash,
    notify => Service[$puppet_agent_service]
  }
}
