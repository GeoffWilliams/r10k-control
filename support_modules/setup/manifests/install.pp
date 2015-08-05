# Symlink directories into the module path and run r10k
class setup::install {
  Exec {
    path => [
      "/opt/puppetlabs/bin",
      "/opt/puppet/bin/",
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
    ]
  }

  File {
    owner => "root",
    group => "root",
    mode  => "0644",
  }

  include setup::params
  $codedir   = $setup::params::codedir
  $hieradir  = $setup::params::hieradir
  $hierafile = $setup::params::hierafile
  $moddir    = $setup::params::moddir
  $pwd       = pwd()

  file { "${moddir}/profiles":
    ensure => link,
    target => "${pwd}/site/profiles",
  }

  file { "${moddir}/roles": 
    ensure => link,
    target => "${pwd}/site/roles",
  }

  file { $hieradir:
    ensure => directory
  }

  file { $hierafile:
    ensure => file,
    source => "${pwd}/hieradata/common.yaml",
  }

}
