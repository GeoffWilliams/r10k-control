# Setup R10K - AKA how we manage updating the puppet environments from git/the
# forge
#
# Params
# [*remote*]
#   The git checkout url of the r10k control repository
# [*environmentpath*]
#   The environmentpath we are using in this puppet version.  Used to tell R10K
#   where to write environments - cannot be used to change the system setting.
# [*proxy*]
#   If you would like to use R10K with a proxy server, pass a value here and it
#   will be configured (in the usual http://user:password@host:port format)
# [*git_config_file*]
#   Location of the git config file that we should add proxy details to
# [*mco_plugin*]
#   Should we install the R10K mcollective publisher?
# [*mco_user*]
#   Name of the mcollective user who we will setup for R10K mcollective 
#   operations
# [*mco_service*]
#   Name of the mcollective service on this puppet version, so that we can
#   restart it after installing the mcollective plugin
# [*generate_r10k_mco_cert*]
#   Should we automatically create the mcollective certificates for the new 
#   mcollective user?  If our mcollective user exists on an unmanaged node
#   then we might want to generate the certificate externally.  For this
#   setting we lookup from heira and fallback to a variable called 
#   `$generate_r10k_mco_cert`.  This lets us override heira using the node
#   classifier and a variable.  If both of these values are `undef` we will
#   perform the default action which is to create the certificates
class profiles::puppet::r10k (
  $remote                 = hiera("profiles::puppet::r10k::remote"),
  $environmentpath        = $::profiles::puppet::params::environmentpath,
  $proxy                  = hiera("profiles::puppet::master::proxy", undef),
  $git_config_file        = $::profiles::puppet::params::git_config_file,
  $mco_plugin             = hiera("profiles::puppet::r10k::mco_plugin", false),
  $mco_user               = hiera("profiles::puppet::r10k::mco_user", false),
  $mco_service            = $::profiles::puppet::params::mco_service,
  $generate_r10k_mco_cert = hiera("profiles::puppet::r10k::generate_mco_cert", $::generate_r10k_mco_cert)
) inherits ::profiles::puppet::params {

  if $remote == undef {
    fail("You must define profiles::puppet::r10k::remote in hiera or pass $remote to class profiles::puppet:r10k")
  }
  validate_absolute_path($git_config_file)
  validate_absolute_path($environmentpath)
  
  if $generate_r10k_mco_cert == undef {
    $_generate_r10k_mco_cert = profiles::puppet::params::generate_r10k_mco_cert
  } else {
    # careful... $create_r10k_mco_cert is true or false at this point, don't 
    # invert the logic of this if statement
    $_generate_r10k_mc_cert = $generate_r10k_mco_cert
  }

 
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

    # setup r10k and configure proxy support
    class { '::r10k::mcollective':
      http_proxy => $proxy,
      notify     => Service[$mco_service],
    }

    # in some circumstances (eg mcollective agent in external collective, we
    # may want to generate the user by hand
    mcollective_user::register { $mco_user:
      generate_cert => $_generate_r10k_mco_cert,
    }
  }
}
