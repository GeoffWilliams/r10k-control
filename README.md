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
_or_
* Puppet Enterprise 3.8.x

# How to use 

## Puppet Enterprise 2015.2.x
1. Install Puppet Enterprise on master
2. `puppet module install --basemodulepath /etc/puppetlabs/code/modules/ zack-r10k`
3. `cd /root`
4. `git clone https://github.com/GeoffWilliams/r10k-control`
5. `ln -s /root/r10k-control/site/profiles /etc/puppetlabs/code/modules/profiles`
6. `ln -s /root/r10k-control/site/roles /etc/puppetlabs/code/modules/roles`
7. `ln -s /root/r10k-control/hieradata/common.yaml /etc/puppetlabs/code/environments/production/hieradata/common.yaml`
8. `puppet apply /root/r10k-control/site/profiles/examples/puppet/r10k_bootstrap.pp`
9. `rm /etc/puppetlabs/code/modules/profiles`
10. `rm /etc/puppetlabs/code/modules/roles`

## Puppet Enterprise 3.8.x
1. Install Puppet Enterprise on master
2. `puppet module install --basemodulepath /etc/puppetlabs/puppet/modules/ zack-r10k`
3. `cd /root`
4. `git clone https://github.com/GeoffWilliams/r10k-control`
5. `ln -s /root/r10k-control/site/profiles /etc/puppetlabs/puppet/modules/profiles`
6. `ln -s /root/r10k-control/site/roles /etc/puppetlabs/puppet/modules/roles`
7. `mkdir /var/lib/hiera -p`
8. `ln -s /root/r10k-control/hieradata/common.yaml /var/lib/hiera/defaults.yaml`
9. `puppet apply /root/r10k-control/site/profiles/examples/puppet/r10k_bootstrap.pp`
10. `rm /etc/puppetlabs/puppet/modules/profiles`
11. `rm /etc/puppetlabs/puppet/modules/roles`

## Optional steps
* Remove any modules that were installed globally under `/etc/puppetlabs/code/modules` either manually or using the `puppet module` tool
* Fork/clone the git repository to your corporate server, then update the common.yaml file to reference it.  Ensure git command is setup with working ssh authentication, proxies, etc

# Post-install
Once r10k has been run once, you should classify your master with `roles::puppet::master` and run puppet to ensure the hiera hierarchy is configured correctly, along with `hiera-eyaml`.

You can then start adding roles and profiles to your own forked repository and classify agent nodes with them.

