# Install common software if configured
#
# Params
# [*packages*]
#   Array of packages to install
class profiles::software(
    $packages = hiera("profiles::software::packages", []),
) {

  if $packages {
    package { $packages:
      ensure => present,
    }
  }
}
