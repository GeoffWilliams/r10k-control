# cleanup the modules we symlinked to prevent strange problems in the future
class setup::cleanup {
  include setup::params
  $codedir   = $setup::params::codedir
  $hieradir  = $setup::params::hieradir
  $hierafile = $setup::params::hierafile
  $moddir    = $setup::params::moddir
  file { "${moddir}/profiles":
    ensure => absent,
  }
  file { "${moddir}/roles":
    ensure => absent,
  }
}
