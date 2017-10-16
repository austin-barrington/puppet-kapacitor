# == Class: kapacitor
#
# A Puppet module for installing InfluxData's kapacitor
#
# === Parameters
#
# [*ensure*]
#   String. State of the kapacitor package. You can also specify a
#   particular version to install.
#
# [*config_file*]
#   String. Path to the configuration file.
#
# [*hostname*]
#   String. Override default hostname used to identify this agent.
#
# [*config*]
#   Hash.  All config held in the file
#
# [*manage_service*]
#   Boolean.  Whether to manage the kapacitor service or not.
#
# [*manage_repo*]
#   Boolean.  Whether or not to manage InfluxData's repo.
#
# [*repo_type*]
#   String.  Which repo (stable, unstable, nightly) to use
#
class kapacitor (
  $ensure                 = $kapacitor::params::ensure,
  $config_file            = $kapacitor::params::config_file,
  $hostname               = $kapacitor::params::hostname,
  $config                 = $kapacitor::params::config,
  $manage_service         = $kapacitor::params::manage_service,
  $manage_repo            = $kapacitor::params::manage_repo,
  $repo_type              = $kapacitor::params::repo_type,
) inherits ::kapacitor::params
{

  validate_string($ensure)
  validate_string($config_file)
  validate_string($hostname)
  validate_hash($config)
  validate_bool($manage_service)
  validate_bool($manage_repo)
  validate_string($repo_type)

  contain ::kapacitor::install
  contain ::kapacitor::config
  contain ::kapacitor::service

  Class['::kapacitor::install'] ->
  Class['::kapacitor::config'] ->
  Class['::kapacitor::service']
}
