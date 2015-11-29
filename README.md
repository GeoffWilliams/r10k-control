# R10K Control Repository
[![Build Status](https://travis-ci.org/GeoffWilliams/r10k-control.svg?branch=production)](https://travis-ci.org/GeoffWilliams/r10k-control)

A basic R10K control repository including:
* Production branch (master is deleted)
* Local roles and profiles site directory
* Access to ready profiles [r_profile](https://forge.puppetlabs.com/geoffwilliams/r_profile)

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
If you wish to install in one hit using the `puppet-enterprise-installer` script by pointing at a control repository, you need only fork this repository and prepare an answers file with the entry `q_puppetmaster_r10k_remote` (and optionally `q_puppetmaster_r10k_private_key`) pointing to your newly forked repository.

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
To enable git to support proxy servers, populate the `r_profile::puppet::master::proxy` key in hiera, eg: 
```
r_profile::puppet::master::proxy: "http://proxy.mycompany.com:8080"
```

# Post-install
Once r10k has been run once, you should classify your master with `role::puppet::master` and run puppet to ensure the hiera hierarchy is configured correctly, along with `hiera-eyaml`.

You can then start adding roles and profiles to your own forked repository and classify agent nodes with them.

The `support_modules` directory may be removed after a successful installation although you may want to keep it around incase you ever need to run the bootstrap script in the future

# Testing
This project comes equiped with RSpec and beaker tests.  They can be run separately or together via a rake task.

## RSpec tests
```shell
bundle install
bundle exec rake spec
```

## Beaker tests
```shell
bundle install
bundle exec rspec spec/acceptance

* The beaker tests are configured to use docker, ensure you have it installed and working before attempting to run the tests
* The required docker image (official centos) and the puppet installer will be downloaded from the internet so connectivity is required.  This hasn't been tested with proxies in place

### Debugging beaker tests
To prevent the test docker instance from being destroyed after a test run, export the BEAKER_destroy variable before running tests, eg:
```shell
export BEAKER_destroy=no
```

You will then be able to `docker ps` to find the VM after your tests are completed:
```shell
geoff ~/vagrant_labs/pe2015/r10k-control $ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                   NAMES
2a2457b39276        f3cf28f75596        "/sbin/init"        About a minute ago   Up About a minute   0.0.0.0:32829->22/tcp   insane_lalande
```

Here we can see that port 22 (SSH) has been bound to local port 32829.  Note that if you use a mac, 0.0.0.0 refers to the VM running docker-machine.  You can find the IP address you need with the command:
```shell
geoff ~/vagrant_labs/pe2015/r10k-control $ docker-machine ip default
192.168.99.100
```

And may then combine the above data into an ssh command:
```shell
ssh -p 32829 root@192.168.99.100
```

The password for root is `root`.



