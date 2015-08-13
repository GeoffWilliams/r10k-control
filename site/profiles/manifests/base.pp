class profiles::base(
    $ntp_servers = hiera("profiles::base::ntp_servers", undef),
) {
  include profiles::puppet::agent
  include profiles::systemd

  class { "ntp":
    disable_monitor => true,
    servers         => $ntp_servers,
  }
}
