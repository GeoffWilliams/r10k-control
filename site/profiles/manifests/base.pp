class profiles::base {
  include profiles::systemd
  class { "ntp":
    disable_monitor => true,
  }
}
