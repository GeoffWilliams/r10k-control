# install required modules
class setup::prepare {
  include setup::params
  Exec {
    path => [
      "/opt/puppetlabs/bin",
      "/opt/puppet/bin/",
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
    ]
  }

  $codedir   = $setup::params::codedir
  $hieradir  = $setup::params::hieradir
  $hierafile = $setup::params::hierafile
  $moddir    = $setup::params::moddir
  $pmiflag   = $setup::params::pmiflag
  $pmi       = "puppet module install ${pmiflag} ${moddir}"

  # Install modules needed for r10k and bootstrapping
  exec { "${pmi} zack-r10k":}
  exec { "${pmi} puppetlabs-stdlib":}
  exec { "${pmi} geoffwilliams-dirtools":}
  exec { "${pmi} geoffwilliams-r_profile":}
}

