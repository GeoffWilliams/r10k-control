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
  $codedir   = $setup::codedir
  $hieradir  = $setup::hieradir
  $hierafile = $setup::hierafile
  $moddir    = $setup::moddir
  $pwd = pwd()

  file { "${pwd}/site/profiles":
    ensure => link,
    target => "${moddir}/profiles",
  }

  file { "${pwd}/site/roles": 
    ensure => link,
    target => "${moddir}/roles",
  }

  file { $hiera_defaults_file:
    ensure => file,
    source => "${pwd}/hieradata/common.yaml",
  }

  # Initial R10K run
  exec { "puppet apply ${pwd}/site/profiles/examples/puppet/r10k_bootstrap.pp": }
}
