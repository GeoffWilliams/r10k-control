# cleanup the modules we symlinked to prevent strange problems in the future
class setup::cleanup {
  include setup::params
  $codedir         = $setup::params::codedir
  $hieradir        = $setup::params::hieradir
  $hierafile       = $setup::params::hierafile
  $moddir          = $setup::params::moddir
  $pwd             = pwd()
  $environmentpath = $setup::params::environmentpath

  Exec {
    path => [
      "/opt/puppetlabs/bin",
      "/opt/puppet/bin/",
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
    ]
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


  # remove symlinks
  file { "${moddir}/profiles":
    ensure => absent,
  }

  file { "${moddir}/roles":
    ensure => absent,
  }

  # remove puppet module install'ed tools
  file { "${moddir}/zack-r10k":
    ensure => absent,
  }

  file { "${moddir}/puppetlabs-stdlib":
    ensure => absent,
  }

  file { "${moddir}/geoffwilliams-dirtools":
    ensure => absent,
  }

  # For beaker test environments, restore the test hieradata
  if $::is_beaker {
    $hieradata_source = "${pwd}/integration_test/hieradata/common.yaml"
    file { $hierafile:
      ensure => file,
      source => $hieradata_source,
    } 
  }

}
