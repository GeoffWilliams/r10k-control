# cleanup the modules we symlinked to prevent strange problems in the future
class setup::cleanup {
  include setup::params
  $codedir   = $setup::codedir
  $hieradir  = $setup::hieradir
  $hierafile = $setup::hierafile
  $moddir    = $setup::moddir
  file { "${moddir}/profiles":
    ensure => absent,
  }
  file { "${moddir}/roles":
    ensure => absent,
  }
}
