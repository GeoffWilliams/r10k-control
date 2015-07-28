# Settings class is a puppet built-in and is a ruby file found at:
# /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/settings.rb
class profile::puppet::params {
  $hieradir = "${::settings::codedir}/environments/%{::environment}/hieradata"
  $basemodulepath = "${::settings::confdir}/modules:/opt/puppetlabs/puppet/modules"
  $environmentpath = "${::settings::codedir}/environments"
}
