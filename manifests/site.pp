# site.pp


if $::kernel == 'windows' {
  Package { provider => chocolatey, }
}

node default {
  include r_role::trusted_fact_classified
}
