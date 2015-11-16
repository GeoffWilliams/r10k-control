require 'spec_helper'
require 'find'

# preconditions indexed by class name.  These will automatically be loaded 
# during testing
$preconditions = {
  "r_profile::puppet::agent" => "class { 'r_profile::systemd': }",
  "r_profile::puppet::master" => "class { 'r_profile::systemd': } service { 'pe-puppetserver': }",
  "r_profile::puppet::policy_based_autosign" => "class { 'r_profile::systemd': } class { 'r_profile::puppet::master': } service { 'pe-puppetserver': }",
  "role::puppet::master" => "class { 'r_profile::systemd': } service { 'pe-puppetserver': }"
}

# parameters indexed by class name.  These will automatically be loaded during
# testing
$params = {
  "r_profile::puppet::r10k" => {
    :remote => "https://github.com/GeoffWilliams/r10k-control/"
  },
  "r_profile::puppet::r10k_mcollective_client" => {
    :user_name        => "r10k",
    :activemq_brokers => "pe-puppet.localdomain"
  }
}

def test_class(classname)
  describe classname do
    let :facts do
      {
        :osfamily               => "RedHat",
        :operatingsystemrelease => "7",
        :pe_server_version      => "2015.2.0",
        :os                     => {
          :family => "RedHat",
        },
      }
    end

    let :pre_condition do
      $preconditions[classname]
    end

    let :params do 
      $params.fetch(classname, {})
    end

    context "class #{classname} should compile without errors" do
      it do
        expect { should compile }.not_to raise_error
      end
    end
  end
end

def classnames(dir)
  classnames = []
  Dir.glob("#{dir}/manifests/**/*.pp") do |manifest|
    if manifest =~ /manifests\/init\.pp/
      # name of module
      classname = File.basename(dir)
    else 
      # name of file
      classname = File.basename(dir) + manifest.gsub("#{dir}/manifests", "").gsub("/", "::").gsub("\.pp","")
    end
    classnames.push(classname)
  end
  return classnames
end


# test all profiles
profile_classes = classnames("site/profile")
if profile_classes then
  profile_classes.each do |profile_class|
    test_class(profile_class)
  end
end

# test all roles
role_classes = classnames("site/role")
if role_classes then
  role_classes.each do |role_class|
    test_class(role_class)
  end
end
