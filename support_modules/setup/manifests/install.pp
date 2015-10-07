# Symlink directories into the module path and run r10k
class setup::install {
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

  # setup local roles + profiles before running r10k so that we can configure
  # for proxies, etc
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

  if $::is_beaker {
    $hieradata_source = "${pwd}/integration_test/hieradata/common.yaml"
  } else {
    $hieradata_source = "${pwd}/hieradata/common.yaml"

  file { $hierafile:
    ensure => file,
    source => $hieradata_source,
  }

}
