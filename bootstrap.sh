#!/bin/bash
PATH="/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"
PUPPET_APPLY="puppet apply --modulepath=$(pwd)/support_modules:$(puppet config print basemodulepath) -e "
$PUPPET_APPLY "include setup::prepare" && \
$PUPPET_APPLY "include setup::install" && \
$PUPPET_APPLY "include setup::cleanup"
