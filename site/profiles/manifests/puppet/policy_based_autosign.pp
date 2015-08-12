class profiles::puppet::policy_based_autosign(
  $ensure           = $profiles::puppet::master::policy_based_autosign_ensure,
  $autosign_script  = $profiles::puppet::master::autosign_script,
  $autosign_secret  = $profiles::puppet::master::autosign_secret,
) {

  if $ensure == present and ! $autosign_secret {
    fail("Cannot enable policy based autosigning without a valid shared secret")
  }
  
  # enable/disable autosign script in puppet.conf
  ini_setting { "puppet_conf_autosign_script":
    ensure  => $ensure,
    path    => "${::settings::confdir}/puppet.conf",
    section => "master",
    setting => "autosign",
    value   => $autosign_script,
    notify  => Service["pe-puppetserver"],
  }

  # the autosigning script
  file { $autosign_script:
    ensure  => $ensure,
    owner   => "root",
    group   => "pe-puppetserver",
    mode    => "0770",
    content => template("${module_name}/autosign.sh.erb"),
  }
}
