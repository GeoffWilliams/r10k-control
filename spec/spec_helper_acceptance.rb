require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
hosts.each do |host|

  # fix locale::facet::_S_create_c_locale name not valid
  on host, "echo 'export LC_ALL=\"en_US.UTF-8\"' >> ~/.bashrc"

  # put puppet binaries on the path so they are usable
  on host, "echo 'export PATH=/opt/puppetlabs/puppet/bin/:${PATH}' >> ~/.bashrc"

  # install puppet - puppet install helper doesn't seem to work with newer 
  # versions of PE:  https://github.com/puppetlabs/beaker-puppet_install_helper
  install_puppet_on(host, {
    :version              => '4.2.1',
    :puppet_agent_version => '1.2.2',
    :default_action       => 'gem_install'
  })

  # scp the puppet file, then run r10k on it.  Needs to be placed in the 
  # directory you want ./modules to appear in
  scp_to host, "#{proj_root}/Puppetfile", "/etc/puppetlabs/code" 
  on host, 'gem install --no-ri --no-rdoc r10k' 
  on host, "cd /etc/puppetlabs/code && r10k puppetfile install --verbose"
  
  # install the roles and profiles modules as regular modules (r10k puppetfile... 
  # doesn't deal with anything not listed in the Puppetfile
  puppet_module_install(:source => "#{proj_root}/site/roles", :module_name => 'roles')
  puppet_module_install(:source => "#{proj_root}/site/profiles", :module_name => 'profiles')
end
