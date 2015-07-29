class profiles::puppet::r10k (
  $remote          = hiera("profiles::puppet::r10k::remote"),
  $environmentpath = $::profiles::puppet::params::environmentpath,
  $proxy           = hiera("profiles::puppet::r10k::proxy", false),
  $git_config_file = $::profiles::puppet::params::git_config_file,
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
    # The following will allow r10k to use Puppetfile via the proxy
    file { $git_config_file:
      ensure => file,
      mode   => "0600",
    }

    Ini_setting {
      ensure  => present,
      path    => $git_config_file,
      value   => $proxy,
    }

    ini_setting { 'git http proxy setting':
      section => 'http',
      setting => 'proxy',
    }

    ini_setting { 'git https proxy setting':
      section => 'https',
      setting => 'proxy',
    }
  }
}
