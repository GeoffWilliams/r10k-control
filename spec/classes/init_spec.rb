require 'spec_helper'
require 'find'

# preconditions indexed by class name.  These will automatically be loaded 
# during testing
$preconditions = {
  "profiles::puppet::agent" => "class { 'profiles::systemd': }",
  "profiles::puppet::master" => "class { 'profiles::systemd': } service { 'pe-puppetserver': }",
  "profiles::puppet::policy_based_autosign" => "class { 'profiles::systemd': } class { 'profiles::puppet::master': } service { 'pe-puppetserver': }",
  "roles::puppet::master" => "class { 'profiles::systemd': } service { 'pe-puppetserver': }"
}

# parameters indexed by class name.  These will automatically be loaded during
# testing
$params = {
  "profiles::puppet::r10k" => {
    :remote => "https://github.com/GeoffWilliams/r10k-control/"
  },
  "profiles::puppet::r10k_mcollective_client" => {
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
profile_classes = classnames("site/profiles")
if profile_classes then
  profile_classes.each do |profile_class|
    test_class(profile_class)
  end
end

# test all roles
role_classes = classnames("site/roles")
if role_classes then
  role_classes.each do |role_class|
    test_class(role_class)
  end
end
