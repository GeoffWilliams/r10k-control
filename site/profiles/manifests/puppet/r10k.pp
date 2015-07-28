class profiles::puppet::r10k (
  $remote = hiera("profiles::puppet::r10k::remote"),
  $environmentpath = $::profiles::puppet::params::environmentpath,
) inherits ::profiles::puppet::params {

  if $remote == undef {
    fail("You must define profiles::puppet::r10k::remote in hiera or pass $remote to class profiles::puppet:r10k")
  }

  file { 'r10k_config':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    path    => '/etc/puppetlabs/r10k/r10k.yaml',
    content => template('profiles/r10k.yaml.erb'),
  }
}
