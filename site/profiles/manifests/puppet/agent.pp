# setup a puppet agent (currently just fixes proxy settings...)
class profiles::puppet::agent(
    $proxy                        = hiera("profiles::puppet::proxy", false),
    $sysconf_puppet               = $::profiles::puppet::params::sysconf_puppet,
    $export_variable              = $::profiles::puppet::params::export_variable,
    $puppet_agent_service         = $::profiles::puppet::params::puppet_agent_service,
) inherits profiles::puppet::params {

  # register the service so we can restart it if needed
  # PE-11353 means we may not need this forever
  service { $puppet_agent_service:
    ensure => running,
    enable => true,
  }

  file { $sysconf_puppet:
    ensure => file,
    owner  => "root",
    group  => "root",
    mode   => "0644",
    notify => [ Service[$puppet_agent_service],
                Exec["systemctl_daemon_reload"] ], 
 }

  #
  # Proxy server monkey patching
  #
  if $proxy {
    $regexp = 'https?://(.*?@)?([^:]+):(\d+)'
    $proxy_host = regsubst($proxy, $regexp, '\2')
    $proxy_port = regsubst($proxy, $regexp, '\3')
  }
  $proxy_ensure = $proxy ? {
    /.*/    => present,
    default => absent,
  }

  if $export_variable {
    # solaris needs a 2-step export
    $http_proxy_var   = "http_proxy=${proxy}; export http_proxy"
    $https_proxy_var  = "https_proxy=${proxy}; export https_proxy"
  } else {
    $http_proxy_var   = "http_proxy=${proxy}"
    $https_proxy_var  = "https_proxy=${proxy}"
  }

  file_line { "puppet agent http_proxy":
    ensure => $proxy_ensure,
    path   => $sysconf_puppet,
    line   => $http_proxy_var,
    match  => "http_proxy=",
  }

  file_line { "puppet agent https_proxy":
    ensure => $proxy_ensure,
    path   => $sysconf_puppet,
    line   => $https_proxy_var,
    match  => "https_proxy=",
  }
}
