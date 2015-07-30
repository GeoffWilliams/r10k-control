class profiles::puppet::r10k (
  $remote          = hiera("profiles::puppet::r10k::remote"),
  $environmentpath = $::profiles::puppet::params::environmentpath,
  $proxy           = hiera("profiles::puppet::r10k::proxy", false),
  $git_config_file = $::profiles::puppet::params::git_config_file,
  $puppetconf      = $::profiles::puppet::params::puppetconf,
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


    # git/proxy support
    file { $git_config_file:
      ensure => file,
      mode   => "0600",
    }

    Ini_setting {
      ensure  => present,
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
  }
}
