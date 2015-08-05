# 
# Bootstrap R10K on this system
# 
class setup::params {
  case $pe_server_version {
    /20/: {
      # Puppet Enterprise 2015.x
      $codedir   = $::settings::codedir
      $hieradir  = "${::settings::codedir}/environments/production/hieradata/"
      $hierafile = "${hieradir}/common.yaml" 
    }
    default: {
      # Puppet Enterprise 3.8x
      $codedir   = $::settings::confdir
      $hieradir  = "/var/lib/hiera"
      $hierafile = "${hieradir}/defaults.yaml"
    }
  }
  $moddir          = "${codedir}/modules"
  $pmiflag         = "--modulepath"
  $environmentpath = "${codedir}/environments/"
}
