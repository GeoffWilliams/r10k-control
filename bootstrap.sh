#!/bin/bash
PATH="/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"
PUPPET_APPLY="puppet apply --modulepath=$(pwd)/support_modules:$(puppet config print basemodulepath) -e "
$PUPPET_APPLY "include setup::prepare" && \
$PUPPET_APPLY "include setup::install" && \
$PUPPET_APPLY "include setup::cleanup"

ls /root/r10k-control -a
ls /etc/puppetlabs/code/environments/production -R
cat /etc/puppet/r10k/r10k.yaml
cat /etc/puppetlabs/code/environments/production/hieradata/common.yaml
/opt/puppetlabs/bin/r10k deploy environment --verbose debug
