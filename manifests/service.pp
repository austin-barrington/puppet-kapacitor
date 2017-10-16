# == Class: kapacitor::service
#
# Optionally manage the kapacitor service.
#
class kapacitor::service {

  assert_private()

  if $::kapacitor::manage_service {
    service { 'kapacitor':
      ensure    => running,
      hasstatus => true,
      enable    => true,
      restart   => 'pkill -HUP kapacitor',
      require   => Class['::kapacitor::config'],
    }
  }
}
