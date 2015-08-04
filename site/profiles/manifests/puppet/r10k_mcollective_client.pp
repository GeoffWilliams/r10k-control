class profiles::puppet::r10k_mcollective_client(
    $user_name = hiera("profiles::puppet::r10k_mcollective_client::user_name"),
    $user_home = hiera("profiles::puppet::r10k_mcollective_client::user_home"),
) {
  
  # r10k mco plugin
  class { "::r10k::mcollective": }

  # MCO certifcates and client
  puppet_enterprise::mcollective::client { $user_name:
    create_user => false,
    home_dir     => $user_home,
  }   
  
}
