class profiles::base {
  include profiles::puppet::agent
  include profiles::systemd

  class { "ntp":
    disable_monitor => true,
  }
}
