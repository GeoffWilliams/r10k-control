# Setup a nice version of vim
class profiles::vim {
  class { 'vim': }

  # install extra bells and whistles for debian
  if $::osfamily == debian {
    package { ["vim-syntax-docker", "vim-syntax-go", "vim-puppet"]: }
  }
}
