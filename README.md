# R10K Control Repository
[![Build Status](https://travis-ci.org/GeoffWilliams/r10k-control.svg?branch=production)](https://travis-ci.org/GeoffWilliams/r10k-control)

A basic R10K control repository including:
* Production branch (master is deleted)
* Local roles and profiles site directory
* Access to ready profiles [r_profile](https://forge.puppetlabs.com/geoffwilliams/r_profile)

# Requirements
* Puppet Enterprise LTR or later point release

# How to use
* Don't base your own R10K repositories on this one, use https://github.com/puppetlabs/control-repo/
* This repository is used for some cool projects I'm working on though :)

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
