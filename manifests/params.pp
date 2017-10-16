# == Class: kapacitor::params
#
# A set of default parameters for Kapacitors's configuration.
#
class kapacitor::params {

  $ensure                 = 'present'
  $config_file            = '/etc/kapacitor/kapacitor.conf'
  $hostname               = $::hostname
  $data_dir               = '/var/lib/kapacitor'
  $skip_config_overrides  = false
  $default_retention_policy = ''
  $config = {
    '[http]' => {
      # HTTP API Server for Kapacitor
      # This server is always on,
      # it serves both as a write endpoint
      # and as the API endpoint for all other
      # Kapacitor calls.
      'bind_address'      => ":9092",
      'log_enabled'       => true,
      'write_tracing'     => false,
      'pprof_enabled'     => false,
      'https_enabled'     => false,
      'https_certificate' => "/etc/ssl/kapacitor.pem"
    },

    '[config-override]' => {
      # Enable/Disable the service for overridding configuration via the HTTP API.
      'enabled' => false
    },

    '[logging]' => {
      # Destination for logs
      # Can be a path to a file or 'STDOUT', 'STDERR'.
      'file'  => "/var/log/kapacitor/kapacitor.log",
      # Logging level can be one of:
      # DEBUG, INFO, WARN, ERROR, or OFF
      'level' => "INFO"
    },

    '[replay]' => {
      # Where to store replay files, aka recordings.
      'dir'  => "/var/lib/kapacitor/replay"
    },

    '[task]' => {
      # Where to store the tasks database
      'dir' => "/var/lib/kapacitor/tasks",
      # How often to snapshot running task state.
      'snapshot-interval' => "60s"
    },

    '[storage]' => {
      # Where to store the Kapacitor boltdb database
      'boltdb' => "/var/lib/kapacitor/kapacitor.db"
    },

    '[deadman]' => {
      # Configure a deadman's switch
      # Globally configure deadman's switches on all tasks.
      # NOTE: for this to be of use you must also globally configure at least one alerting method.
      'global' => false,
      # Threshold, if globally configured the alert will be triggered if the throughput in points/interval is <=> threshold.
      'threshold' => '0.0',
      # Interval, if globally configured the frequency at which to check the throughput.
      'interval' => "10s",
      # Id -- the alert Id, NODE_NAME will be replaced with the name of the node being monitored.
      'id' => "node 'NODE_NAME' in task '{{ .TaskName }}'",
      # The message of the alert. INTERVAL will be replaced by the interval.
      'message' => "{{ .ID }} is {{ if eq .Level \"OK\" }}alive{{ else }}dead{{ end }}: {{ index .Fields \"collected\" | printf \"%0.3f\" }} points/INTERVAL."
    },

    '[[influxdb]]' => {
      'enabled'                           => true,
      'default'                           => true,
      'name'                              => "influxdb",
      'urls'                              => "[\"http://localhost:8086\"]",
      'username'                          => "",
      'password'                          => "",
      'timeout'                           => 0,
      'insecure-skip-verify'              => false,
      'startup-timeout'                   => "5m",
      'disable-subscriptions'             => false,
      'subscription-protocol'             => "http",
      'subscriptions-sync-interval'       => "1m0s",
      'kapacitor-hostname'                => "",
      'http-port'                         => 0,
      'udp-bind'                          => "",
      'udp-buffer'                        => 1000,
      'udp-read-buffer'                   => 0,
      '[influxdb.subscriptions]'          => {
      },
      '[influxdb.excluded-subscriptions]' => {
      }
    },
    '[smtp]' => {
      'enabled' => false,
      'host' => "localhost",
      'port' => 25,
      'username' => "",
      'password' => "",
      'from' => "",
      'to' => ["oncall@example.com"],
      'no-verify' => false,
      'idle-timeout' => "30s",
      'global' => false,
      'state-changes-only' => false
    },
    '[snmptrap]' => {
      'enabled' => false,
      'addr' => "localhost:162",
      'community' => "kapacitor",
      'retries' => 1
    },
    '[pagerduty]' => {
      'enabled' => false,
      'service-key' => "",
      'url' => "https://events.pagerduty.com/generic/2010-04-15/create_event.json",
      'global' => false
    },
    '[slack]' => {
      'enabled' => false,
      'url' => "",
      'channel' => "",
      'global' => false,
      'state-changes-only' => true
    },
    '[stats]' => {
      'enabled'          => true,
      'stats-interval'   => "10s",
      'database'         => "_kapacitor",
      'retention-policy' => "autogen"
    }
  }
  $manage_service         = true
  $manage_repo            = true
  $repo_type              = 'stable'
}
