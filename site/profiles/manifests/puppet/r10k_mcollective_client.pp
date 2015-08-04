class profiles::puppet::r10k_mcollective_client(
    $user_name = hiera("profiles::puppet::r10k_mcollective_client::user_name"),
    $user_home = hiera("profiles::puppet::r10k_mcollective_client::user_home"),
    $mcollective_brokers = hiera("profiles::puppet::r10k_mcollective_client::activemq_brokers"),
) {
  
  # r10k mco plugin
  class { "::r10k::mcollective": }

  # MCO certifcates and client
  puppet_enterprise::mcollective::client { $user_name:
    mcollective_brokers => $mcollective_brokers,
    create_user         => false,
    home_dir            => $user_home,
  }   
  
}
