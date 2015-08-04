class profiles::puppet::r10k_mcollective_client(
    $user_name = hiera("profiles::puppet::r10k_mcollective_client::user_name"),
    $user_home = hiera("profiles::puppet::r10k_mcollective_client::user_home"),
    $activemq_brokers = hiera("profiles::puppet::r10k_mcollective_client::activemq_brokers"),
    $logfile = false,
) {
  
  # If user supplies custom logdir use it and have user be responsible for
  # creating directory structure, etc.  Otherwise just create a directory
  # under /var/log and allow access
  if $logfile {
    $_logfile = $logfile
  } else {
    $logdir = "/var/log/mcollective_${user_name}"
    $_logfile = "${logdir}/mcollective.log"
    file { $logdir:
      ensure => directory,
      owner  => $user_name,
      group  => $user_name,
      mode   => "0755",
    }
  }

  # r10k mco plugin
  class { "::r10k::mcollective": }

  # MCO certifcates and client
  puppet_enterprise::mcollective::client { $user_name:
    activemq_brokers => $activemq_brokers,
    create_user      => false,
    home_dir         => $user_home,
    logfile          => $_logfile,
  }   
  
}