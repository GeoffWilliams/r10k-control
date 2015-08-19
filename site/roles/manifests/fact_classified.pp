# Classify a by including the role class denoted by the `$::role` variable
# which should be specified by an external fact present on the agent node 
class roles::fact_classified {
  include $::role
}
