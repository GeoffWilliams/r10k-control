class profiles::systemd {

  # Provide a graph node that we can notify to get systemd to reload itself.  
  # If this is not a systemd controlled system, we simply run the true command
  # instead so that we can exit with status 0
  if $::osfamily == 'RedHat' {
    if $::operatingsystemrelease =~ /^7/ or $::operatingsystem == 'Fedora' {
      $command = "systemctl daemon-reload"
    } else {
      $command = "true"
    }
  }

  exec { "systemctl_daemon_reload":
    command     => $command,
    refreshonly => true,
    path        => "/bin:/usr/bin:/usr/local/bin"
  }
}
