require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))


hosts.each do |host|
  # external fact to indicate we are running beaker - gets picked up during 
  # bootstrap puppet code
  on host, "mkdir -p /etc/facter/facts.d && echo 'is_beaker=true' > /etc/facter/facts.d/beaker.txt"

  scp_to host, "#{proj_root}", "/root",  {:verbose => :debug}

  # bootstrap!  Note that initial 'test' hieradata is selected in
  on host, "cd /root/r10k-control && ./bootstrap.sh"
  on host, "puppet module install --force geoffwilliams-puppet_enterprise"

end
