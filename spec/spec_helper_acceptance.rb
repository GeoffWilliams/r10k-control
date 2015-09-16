require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))


hosts.each do |host|

  # bootstrap!
  scp_to host, "#{proj_root}", "/root", {:ignore => ".git/hooks/pre-commit"}
  on host, "cd /root/r10k-control && ./bootstrap.sh"
  on host, "puppet module install --force geoffwilliams-puppet_enterprise"


  # override 'real' hieradata with integration test data
  hiera_dir = "/etc/puppetlabs/code/environments/production/hieradata"
  scp_to host, "#{proj_root}/integration_test/hieradata/common.yaml", hiera_dir
end
