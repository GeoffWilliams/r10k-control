class role::puppet::master {
  include profile::base
  include r_profile::puppet::r10k
  include r_profile::puppet::master
}
