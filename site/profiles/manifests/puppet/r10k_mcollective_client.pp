class profiles::puppet::r10k_mcollective_client(
    $user_name = hiera("profiles::puppet::r10k::mco_user"),
    $user_home = hiera("profiles::puppet::r10k_mcollective_client::user_home"),
    $activemq_brokers = hiera("profiles::puppet::r10k_mcollective_client::activemq_brokers"),
) {

  if $user_home {
    $_user_home = $user_home
  } else {
    $_user_home = undef   
  }  

  # r10k mco plugin
  class { "::r10k::mcollective": }

  # MCO certifcates and client
  mcollective_user::client { $user_name:
    activemq_brokers => $activemq_brokers,
    user_home        => $undef
  }
}
