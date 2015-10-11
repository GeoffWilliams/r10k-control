class profiles::base(
    $ntp_servers = hiera("profiles::base::ntp_servers", undef),
) {
  include profiles::puppet::agent
  include profiles::systemd
  include profiles::motd 
  include profiles::software

  if $virtual != "docker" {
    class { "ntp":
      disable_monitor => true,
      servers         => $ntp_servers,
    }
  }
}
