# == Class: kapacitor::config
#
# Templated generation of kapacitor.conf
#
class kapacitor::config inherits kapacitor {

  assert_private()

  file { $::kapacitor::config_file:
    ensure  => file,
    content => template('kapacitor/kapacitor.conf.erb'),
    mode    => '0640',
    owner   => 'kapacitor',
    group   => 'kapacitor',
    notify  => Class['::kapacitor::service'],
    require => Class['::kapacitor::install'],
  }
}
