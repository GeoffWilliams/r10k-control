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

## Automatic installation on Puppet Enterprise 2015.x and 3.8.x
1. Install Puppet Enterprise on master
1. Checkout this git repository somewhere (or fork it)
1. Run the script `./bootstrap.sh`


## Installer-native installation
If you wish to install in one hit using the `puppet-enterprise-installer` script by pointing at a control repository, you need only fork this repository and prepare an answers file with the entry `XXXXXX` pointing to your newly forked repository.

## Manual installation

### Puppet Enterprise 2015.2.x
1. Install Puppet Enterprise on master
1. `puppet module install --basemodulepath /etc/puppetlabs/code/modules/ zack-r10k`
1. `puppet module install --basemodulepath /etc/puppetlabs/code/modules/ puppetlabs-stdlib`
1. `cd /root`
1. `git clone https://github.com/GeoffWilliams/r10k-control`
1. `ln -s /root/r10k-control/site/profiles /etc/puppetlabs/code/modules/profiles`
1. `ln -s /root/r10k-control/site/roles /etc/puppetlabs/code/modules/roles`
1. `cp /root/r10k-control/hieradata/common.yaml /etc/puppetlabs/code/environments/production/hieradata/common.yaml`
1. `puppet apply /root/r10k-control/site/profiles/examples/puppet/r10k_bootstrap.pp`
1. `rm /etc/puppetlabs/code/modules/profiles`
1. `rm /etc/puppetlabs/code/modules/roles`

### Puppet Enterprise 3.8.x
1. Install Puppet Enterprise on master
1. `puppet module install --basemodulepath /etc/puppetlabs/puppet/modules/ zack-r10k`
1. `puppet module install --basemodulepath /etc/puppetlabs/puppet/modules/ puppetlabs-stdlib`
1. `cd /root`
1. `git clone https://github.com/GeoffWilliams/r10k-control`
1. `ln -s /root/r10k-control/site/profiles /etc/puppetlabs/puppet/modules/profiles`
1. `ln -s /root/r10k-control/site/roles /etc/puppetlabs/puppet/modules/roles`
1. `mkdir /var/lib/hiera -p`
1. `cp /root/r10k-control/hieradata/common.yaml /var/lib/hiera/defaults.yaml`
9. `puppet apply /root/r10k-control/site/profiles/examples/puppet/r10k_bootstrap.pp`
1. `rm /etc/puppetlabs/puppet/modules/profiles`
1. `rm /etc/puppetlabs/puppet/modules/roles`

## Optional steps
* Remove any modules that were installed globally under `/etc/puppetlabs/code/modules` either manually or using the `puppet module` tool
* Fork/clone the git repository to your corporate server, then update the common.yaml file to reference it.  Ensure git command is setup with working ssh authentication, proxies, etc

## Proxy support
To enable git to support proxy servers, populate the `profiles::puppet::r10k::proxy` key in hiera, eg: 
```
profiles::puppet::r10k::proxy: "http://proxy.mycompany.com:8080"
```

# Post-install
Once r10k has been run once, you should classify your master with `roles::puppet::master` and run puppet to ensure the hiera hierarchy is configured correctly, along with `hiera-eyaml`.

You can then start adding roles and profiles to your own forked repository and classify agent nodes with them.

The `support_modules` directory may be removed after a successful installation although you may want to keep it around incase you ever need to run the bootstrap script in the future
