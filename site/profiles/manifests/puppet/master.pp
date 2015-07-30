class profiles::puppet::master (
    $hiera_eyaml = true,
    $autosign = false,
#    $deploy_pub_key = "",
#    $deploy_private_key = "",
#    $environmentpath = $::profile::puppet::params::environmentpath,
) inherits profiles::puppet::params {
  validate_bool($hiera_eyaml,$autosign)

  File {
    owner => "root",
    group => "root",
  }

  class { "hiera":
    hierarchy => [
      "nodes/%{clientcert}",
      "app_tier/%{app_tier}",
      "env/%{environment}",
      "common",
    ],
    datadir   => $profiles::puppet::params::hieradir,
    backends  => $backends,
    eyaml     => $hiera_eyaml,
    owner     => "pe-puppet",
    group     => "pe-puppet",
    provider  => "pe_puppetserver_gem",
    notify    => Service["pe-puppetserver"],
  }

  if $autosign {
    file { "autosign":
      ensure  => "present",
      content => "*",
      path    => "${::settings::confdir}/autosign.conf",
    }
  }

}
