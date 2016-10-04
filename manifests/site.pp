# site.pp

if $::kernel == 'windows' {
  Package { provider => chocolatey, }
}


resources { 'firewall':
  purge => true,
}

Firewall {
  before  => Class['r_profile::fw::post'],
  require => Class['r_profile::fw::pre'],
}

node default {
  include r_role::trusted_fact_classified
}
