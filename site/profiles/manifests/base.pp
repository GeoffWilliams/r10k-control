class profiles::base {
  class { "ntp":
    disable_monitor => true,
  }
}
