# Classify a by including the role class denoted by the `$::role` variable
# which should be specified by an external fact present on the agent node 
class role::fact_classified {
  # always include our base SOE if no role is specified.  Don't just
  # randomly always include profiles::base as this could have unwanted
  # side effects if we need to exclude it for some reason
  if $::role {
    include $::role
  } else {
    include profile::base
  }
}
