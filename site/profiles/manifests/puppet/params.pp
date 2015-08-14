# Settings class is a puppet built-in and is a ruby file found at:
# /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/settings.rb
class profiles::puppet::params {

  if $pe_server_version or $aio_agent_version {
    # PE 2015/AIO agent
    $puppet_agent_service = "puppet"
    $_codedir             = $::settings::codedir
    $mco_service          = "mcollective"
  } else {
    # setup for PE 3.8x -- we don't support OSS puppet with this module anyway...
    $puppet_agent_service = "pe-puppet"
    $_codedir             = $::settings::confdir
    $mco_service          = "pe-mcollective"
  }


  # os-specific settings
  case $::osfamily {
    "debian": {
      # fixme - check this!
      warning("debian is untested with profiles::puppet::params!")
      $sysconf_dir      = "/etc/default"
      $export_variable  = true
    }
    "redhat": {
      $sysconf_dir = "/etc/sysconfig"
    }
    "solaris": {
      $sysconf_dir      = "/lib/svc/method"
      $export_variable  = true
    }
    default: {
      notify { "Unsupported osfamily ${::osfamily} in profiles::puppet::params": }
    }
  }


  # systemd detection
  if $::osfamily == 'RedHat' {
    if $::operatingsystemrelease =~ /^7/ or $::operatingsystem == 'Fedora' {
      # we are using systemd, we must NOT export a variable
      $export_variable = false
    } else {
      $export_variable = true
    }
  } else {
    warning ("systemd detection in profiles::puppet::params doesn't support non-redhat os")
  }

  $sysconf_puppetserver   = "${sysconf_dir}/pe-puppetserver"
  $sysconf_puppet         = "${sysconf_dir}/${puppet_agent_service}"
  $hieradir               = "${_codedir}/environments/%{::environment}/hieradata"
  $basemodulepath         = "${::settings::confdir}/modules:/opt/puppetlabs/puppet/modules"
  $environmentpath        = "${_codedir}/environments"
  $git_config_file        = "/root/.gitconfig"
  $puppetconf             = "${::settings::confdir}/puppet.conf"
  $generate_r10k_mco_cert = true
  $autosign_script        = "/usr/local/bin/autosign.sh"
}
