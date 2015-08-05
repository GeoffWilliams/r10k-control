class profiles::puppet::r10k (
  $remote          = hiera("profiles::puppet::r10k::remote"),
  $environmentpath = $::profiles::puppet::params::environmentpath,
  $proxy           = hiera("profiles::puppet::master::proxy", false),
  $git_config_file = $::profiles::puppet::params::git_config_file,
  $puppetconf      = $::profiles::puppet::params::puppetconf,
  $mco_plugin      = hiera("profiles::puppet::r10k::mco_plugin", false),
  $mco_user        = hiera("profiles::puppet::r10k::mco_user", false),
  $mco_service     = $::profiles::puppet::params::mco_service,
) inherits ::profiles::puppet::params {

  if $remote == undef {
    fail("You must define profiles::puppet::r10k::remote in hiera or pass $remote to class profiles::puppet:r10k")
  }
  validate_absolute_path($git_config_file)
  validate_absolute_path($environmentpath)
 
  File {
    owner   => "root",
    group   => 0,
    mode    => "0644"
  }

  file { "r10k_config":
    ensure  => file,
    path    => "/etc/puppetlabs/r10k/r10k.yaml",
    content => template("profiles/r10k.yaml.erb"),
  }

  if $proxy {
    $regexp = 'https?://(.*?@)?([^:]+):(\d+)'
    $proxy_host = regsubst($proxy, $regexp, '\2')
    $proxy_port = regsubst($proxy, $regexp, '\3')
  }

  $proxy_ensure = $proxy ? {
    /.*/    => present,
    default => absent,
  }

  # git/proxy support (see also r10k.yaml)
  file { $git_config_file:
    ensure => file,
    mode   => "0600",
  }

  Ini_setting {
    ensure  => $proxy_ensure,
  }

  ini_setting { 'git http proxy setting':
    section => 'http',
    setting => 'proxy',
    path    => $git_config_file,
    value   => $proxy,
  }

  ini_setting { 'git https proxy setting':
    section => 'https',
    setting => 'proxy',
    path    => $git_config_file,
    value   => $proxy,
  }

  if $mco_plugin {

    if $proxy {
      $mco_proxy = $proxy
    } else {
      $mco_proxy = undef
    }
  
    # setup r10k and configure proxy support
    class { '::r10k::mcollective':
      http_proxy => $mco_proxy,
      notify     => Service[$mco_service],
    }

    mcollective_user::register { $mco_user: }
  }
}
