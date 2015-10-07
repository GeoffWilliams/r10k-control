require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))


hosts.each do |host|

  # bootstrap!
  scp_to host, "#{proj_root}", "/root", {:ignore => ".git/hooks/pre-commit"}
  on host, "cd /root/r10k-control && ./bootstrap.sh"
  on host, "puppet module install --force geoffwilliams-puppet_enterprise"

  # external fact to indicate we are running beaker - gets picked up during 
  # bootstrap puppet code
  on host, "mkdir -p /etc/facter/facts.d && echo is_beaker=true > beaker.txt"
end
