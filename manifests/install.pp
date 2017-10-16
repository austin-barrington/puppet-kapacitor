# == Class: kapacitor::install
#
# Conditionally handle InfluxData's official repos and install the necessary
# kapacitor package.
#
class kapacitor::install {

  assert_private()

  $_operatingsystem = downcase($::operatingsystem)

  if $::kapacitor::manage_repo {
    case $::osfamily {
      'Debian': {
        apt::source { 'influxdata':
          comment  => 'Mirror for InfluxData packages',
          location => "https://repos.influxdata.com/${_operatingsystem}",
          release  => $::lsbdistcodename,
          repos    => $::kapacitor::repo_type,
          key      => {
            'id'     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
            'source' => 'https://repos.influxdata.com/influxdb.key',
          },
        }
        Class['apt::update'] -> Package['kapacitor']
      }
      'RedHat': {
        yumrepo { 'influxdata':
          descr    => 'influxdata',
          enabled  => 1,
          baseurl  => "https://repos.influxdata.com/rhel/${::operatingsystemmajrelease}/${::architecture}/${::kapacitor::repo_type}",
          gpgkey   => 'https://repos.influxdata.com/influxdb.key',
          gpgcheck => true,
        }
        Yumrepo['influxdata'] -> Package['kapacitor']
      }
      default: {
        fail('Only RedHat, CentOS, Debian and Ubuntu are supported at this time')
      }
    }
  }

  ensure_packages(['kapacitor'], { ensure => $::kapacitor::ensure })

}
