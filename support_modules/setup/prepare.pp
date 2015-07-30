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

  $codedir   = $setup::codedir
  $hieradir  = $setup::hieradir
  $hierafile = $setup::hierafile
  $moddir    = $setup::moddir
  $pmi       = "puppet module install --basemodulepath ${moddir}"

  # Install modules needed for r10k
  exec { "${pmi} zack-r10k":}
  exec { "${pmi} puppetlabs-stdlib":}
  exec { "${pmi} geoffwilliams/coolstuff": }
}

