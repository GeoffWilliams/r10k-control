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
  $pwd = pwd()

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

  # Script to get the git revision of the current environment.  Needs to be 
  # bootstrapped onto the system or puppet wont run at all
  file { "/usr/local/bin/puppet_git_revision.sh":
    ensure  => file,
    content => template("profiles/puppet_git_revision.sh.erb"),
    mode    => "0755",
  }

  # Initial R10K run
  exec { "puppet apply ${pwd}/site/profiles/examples/puppet/r10k_bootstrap.pp": }
}
