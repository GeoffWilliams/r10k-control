class role::puppet::master {
  include r_profile::base
  include r_profile::puppet::r10k
  include r_profile::puppet::master
}
