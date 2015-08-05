# Settings class is a puppet built-in and is a ruby file found at:
# /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/settings.rb
class profiles::puppet::params {

  if $pe_server_version {
    # PE 2015
    $sysconf_puppet = "/etc/sysconfig/puppet"
    $puppet_agent_service = "puppet"
    $_codedir = $::settings::codedir
    $mco_service = "mcollective"
  } else {
    $sysconf_puppet = "/etc/sysconfig/pe-puppet"
    $puppet_agent_service = "pe-puppet"
    $_codedir = $::settings::confdir
    $service  = "pe-mcollective"
  }

  if $::osfamily == 'RedHat' {
    if $::operatingsystemrelease =~ /^7/ or $::operatingsystem == 'Fedora' {
      $sysconf_prefix = ""
    } else {
      $sysconf_prefix = "export "
    }
  } else {
    notify { "Warning: systemd detection doesn't support non-redhat os": }
  }

  $sysconf_puppetserver = "/etc/sysconfig/pe-puppetserver"
  $hieradir = "${_codedir}/environments/%{::environment}/hieradata"
  $basemodulepath = "${::settings::confdir}/modules:/opt/puppetlabs/puppet/modules"
  $environmentpath = "${_codedir}/environments"
  $git_config_file = "/root/.gitconfig"
  $puppetconf = "${::settings::confdir}/puppet.conf"
}
