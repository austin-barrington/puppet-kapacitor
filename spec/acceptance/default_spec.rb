require 'spec_helper_acceptance'

describe 'kapacitor' do
  context 'default server' do
      it 'should work with no errors' do

        pp = <<-EOS
            Exec {
              path => '/bin:/usr/bin:/sbin:/usr/sbin',
            }

            class { '::kapacitor':
              ensure         => '1.3.0',
              hostname       => 'test.vagrant.dev',
              config         => {
                '[[influxdb]]' => {
                  'enabled'                           => true,
                  'default'                           => true,
                  'name'                              => "influxdb",
                  'urls'                              => ["http://localhost:8086"],
                  'username'                          => "kapacitor",
                  'password'                          => "metricsmetricsmetrics",
                  '[influxdb.subscriptions]'.         => {
                    'server_stats' => "[ \"default\" ]"
                  },
                  '[influxdb.excluded-subscriptions]' => {
                  }
                },
              },
              manage_service => false,
              manage_repo    => false
            }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, :catch_failures => true)
        expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero

      end

      describe package('kapacitor') do
        it { should be_installed }
      end

      describe service('kapacitor') do
        it { should be_running }
      end

      describe file ('/etc/kapacitor/kapacitor.conf') do
          it { should be_file }
          it { should contain '[agent]' }
          it { should contain '  hostname = "test.vagrant.dev"' }
          it { should contain '[[influxdb]]' }
          it { should contain '  urls = ["http://localhost:8086"]' }
          it { should contain '  database = "kapacitor"' }
          it { should contain '  username = "kapacitor"' }
          it { should contain '  password = "metricsmetricsmetrics"' }
          it { should contain '  [influxdb.subscriptions]'}
          it { should contain '    server_stats => [ "default" ]'}
          it { should contain '  [influxdb.excluded-subscriptions]'}
      end

  end
end
