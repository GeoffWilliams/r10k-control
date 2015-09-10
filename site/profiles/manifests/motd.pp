# simple MOTD support for linux
#
# [params]
# *template*
#   template FILE to use for the MOTD 
# *inline_template*
#   string to be processed as an inline template for the MOTD
class profiles::motd(
    $template         = hiera("profiles::motd::template", "motd/motd.erb"),
    $inline_template  = hiera("profiles::motd::inline_template", ""),
) {

  class { "::motd": 
    template        => $template,
    inline_template => $inline_template,
  }
}
