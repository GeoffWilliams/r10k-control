# R10K Control Repository
A basic R10K control repository including:
* Production branch (master is deleted)
* Local roles and profiles site directory
* Hiera hierachy configured
* hiera-eyaml as drop-in replacement for yaml
* Puppetfile with a couple of forge modules
* zack/r10k forge module used to setup R10K

# Requirements
* Puppet Enterprise 2015.02

# How to use
1. Install Puppet Enterprise on master
2. `puppet module install --basemodulepath /etc/puppetlabs/code/modules/ zack-r10k`
3. `cd /root`
4. `git clone https://github.com/GeoffWilliams/r10k-control`
5. `ln -s /root/r10k-control/site/profiles /etc/puppetlabs/code/modules/profiles`
6. `ln -s /root/r10k-control/site/roles /etc/puppetlabs/code/modules/roles`
8. `puppet apply /root/r10k-control/site/profiles/examples/puppet/r10k_bootstrap.pp`
