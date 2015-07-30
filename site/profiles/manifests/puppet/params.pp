# Settings class is a puppet built-in and is a ruby file found at:
# /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/settings.rb
class profiles::puppet::params {

  $_codedir = $pe_server_version ? {
    /20/    => $::settings::codedir,
    default => $::settings::confdir,
  }

  $hieradir = "${_codedir}/environments/%{::environment}/hieradata"
  $basemodulepath = "${::settings::confdir}/modules:/opt/puppetlabs/puppet/modules"
  $environmentpath = "${_codedir}/environments"
  $git_config_file = "/root/.gitconfig"
  $puppetconf = "/etc/puppetlabs/puppet/puppet.conf"
}
