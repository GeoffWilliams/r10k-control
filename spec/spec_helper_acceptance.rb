require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))


hosts.each do |host|
  # external fact to indicate we are running beaker - gets picked up during 
  # bootstrap puppet code
  on host, "mkdir -p /etc/facter/facts.d && echo 'is_beaker=true' > /etc/facter/facts.d/beaker.txt"

#  scp_to host, "#{proj_root}", "/root",  {:verbose => :debug}

  Net::SSH.start(host["ip"], host[:ssh][:user], {:password =>  host[:ssh][:password], :port => host[:ssh][:port]}) do |ssh|
    ssh.scp.upload!(proj_root, "/root", :recursive => true) do |ch, name, sent, total|
      puts "#{name}: #{sent}/#{total}"
    end
  end



  # bootstrap!  Note that initial 'test' hieradata is selected in
  on host, "cd /root/r10k-control && ./bootstrap.sh"
  on host, "puppet module install --force geoffwilliams-puppet_enterprise"

end
