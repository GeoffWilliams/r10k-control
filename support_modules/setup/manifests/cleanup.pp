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
    ],
    logoutput => true,
    timeout   => 0,
  }

  # Initial R10K run
  exec { "puppet apply ${pwd}/site/profile/examples/puppet/r10k_bootstrap.pp": }

  # remove all global modules to avoid namespace pollution once the system is up
  exec { "rm -rf ${moddir}/*": }

  # For beaker test environments, restore the test hieradata
  if $::is_beaker {
    $hieradata_source = "${pwd}/integration_test/hieradata/common.yaml"
    file { $hierafile:
      ensure => file,
      source => $hieradata_source,
    } 
  }

}
