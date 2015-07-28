# bootstrap a new R10K installation
#
# Steps:
# 1.  Create an r10k.yaml file
# 2.  Run r10k
#
# Note:
# * Must have hiera data installed pointing to r10k control repository at the
# key `profiles::puppet::r10k::remote:` 
class { "profiles::puppet::r10k":}
exec { "/opt/puppetlabs/bin/r10k -v deploy environment": }
