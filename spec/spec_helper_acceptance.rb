require 'pry'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
#pe_tarball = "/root/pe.tar.gz"


hosts.each do |host|

  # fix locale::facet::_S_create_c_locale name not valid
 # on host, "echo 'export LC_ALL=\"en_US.UTF-8\"' >> ~/.bashrc"

  # put puppet binaries on the path so they are usable
#  on host, "echo 'export PATH=/opt/puppetlabs/puppet/bin/:${PATH}' >> ~/.bashrc"

  # install puppet - puppet install helper doesn't seem to work with newer 
  # versions of PE:  https://github.com/puppetlabs/beaker-puppet_install_helper
#  install_puppet_on(host, {
#    :version              => '4.2.1',
#    :puppet_agent_version => '1.2.2',
#    :default_action       => 'gem_install'
#  })

  # download the PE installer to the VM...
#  on host, "wget -O #{pe_tarball} 'https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest'"
  
  # extract the tarball, stripping of the version...
#  on host, "mkdir /root/pe && cd /root/pe && tar --strip-components 1 -zxvf #{pe_tarball}"

  # run the installer... Zzzzzz
#  scp_to host, "#{proj_root}/integration_test/beaker-answers.txt", "/root"
#  on host, "cd /root/pe && ./puppet-enterprise-installer -a /root/beaker-answers.txt"

  # scp the puppet file, then run r10k on it.  Needs to be placed in the 
  # directory you want ./modules to appear in
  scp_to host, "#{proj_root}/Puppetfile", "/etc/puppetlabs/code" 
#  on host, 'gem install --no-ri --no-rdoc r10k' 
  on host, "cd /etc/puppetlabs/code && r10k puppetfile install --verbose"

  # install the roles and profiles modules as regular modules (r10k puppetfile... 
  # doesn't deal with anything not listed in the Puppetfile).  Have to use 
  # SCP because puppet_module_install() puts modules in the old directory...
  scp_to host, "#{proj_root}/site/roles", "/etc/puppetlabs/code/modules"
  scp_to host, "#{proj_root}/site/profiles", "/etc/puppetlabs/code/modules"

  # manually install the mock puppet_enterprise module.  If we try to use the 
  # real one in puppet apply mode, it will destroy the system because it needs
  # access to resource collectors. There appears to be no other way to do this.
  # We only need puppet enterprise module to create the pe-puppetserver service
  # for us and to avoid compile failures anyway...
  on host, "puppet module install --force geoffwilliams-puppet_enterprise"


  # hiera data
  hiera_dir = "/root/spec/fixtures/hieradata/"
  on host, "mkdir -p #{hiera_dir}"
  scp_to host, "#{proj_root}/integration_test/hiera.yaml", "/etc/puppetlabs/code"
  scp_to host, "#{proj_root}/integration_test/hieradata/testdata.yaml", hiera_dir
end
