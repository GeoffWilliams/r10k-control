class roles::puppet::master {
  include profiles::base
  include profiles::puppet::r10k
  include profiles::puppet::master
}
