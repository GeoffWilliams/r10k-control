require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))


hosts.each do |host|
  # external fact to indicate we are running beaker - gets picked up during 
  on host, "mkdir -p /etc/facter/facts.d && echo 'is_beaker=true' > /etc/facter/facts.d/beaker.txt"
  # scp the current directory.  exclude the `vendor` subdirectory which is
  # where travis-ci stores tons of gem files, otherwise it takes forever
  # and fails the build
  scp_to host, "#{proj_root}", "/root",  {:ignore => "vendor"}


  # bootstrap!  Note that initial 'test' hieradata is selected in
  on host, "cd /root/r10k-control && ./bootstrap.sh"
  on host, "puppet module install --force geoffwilliams-puppet_enterprise"
end
