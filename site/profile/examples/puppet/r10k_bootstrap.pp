# bootstrap a new R10K installation
#
# Steps:
# 1.  Create an r10k.yaml file
# 2.  Run r10k
#
# Note:
# * Must have hiera data installed pointing to r10k control repository at the
# key `profiles::puppet::r10k::remote:` 

# Must install real version of git before running r10k as otherwise it will
# attempt to use a weird ruby version that doesn't seem to support proxies
include r_profile::puppet::params
$mco_service = $r_profile::puppet::params::mco_service

package { "git":
  ensure => present,
}

service { $mco_service:
  ensure => running,
  enable => true,
}

class { "r_profile::puppet::r10k":}
exec { "r10k deploy environment -p --verbose debug": 
  path => [
    "/opt/puppetlabs/bin",
    "/opt/puppet/bin/",
    "/usr/local/bin",
    "/usr/bin",
    "/bin",
  ],
  logoutput => true,
}

