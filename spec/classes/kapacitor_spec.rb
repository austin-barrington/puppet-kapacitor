require 'spec_helper'

describe 'kapacitor' do
  context 'Supported operating systems' do
    ['RedHat', ].each do |osfamily|
      [6,7].each do |releasenum|
        context "RedHat #{releasenum} release specifics" do
          let(:facts) {{
            :osfamily                  => 'RedHat',
            :architecture              => 'x86_64',
            :kernel                    => 'Linux',
            :operatingsystem           => osfamily,
            :operatingsystemrelease    => releasenum,
            :operatingsystemmajrelease => releasenum,
            :role                      => 'kapacitor'
          }}
          it { should compile.with_all_deps }
          it { should contain_class('kapacitor::config') }
          it { should contain_class('kapacitor::install') }
          it { should contain_class('kapacitor::params') }
          it { should contain_class('kapacitor::service') }
          it { should contain_class('kapacitor')
            .with(
              :ensure         => '',
              
            )
          }
          it { should contain_file('/etc/kapacitor/kapacitor.conf') }
          it { should contain_package('kapacitor') }
          it { should contain_service('kapacitor') }
          it { should contain_yumrepo('influxdata')
            .with(
              :baseurl => "https://repos.influxdata.com/rhel/#{facts[:operatingsystemmajrelease]}/#{facts[:architecture]}/stable",
            )
          }

          describe 'allow custom repo_type' do
            let(:params) { {:repo_type => 'unstable' } }
            it { should contain_yumrepo('influxdata')
              .with(
                :baseurl => "https://repos.influxdata.com/rhel/#{facts[:operatingsystemmajrelease]}/#{facts[:architecture]}/unstable",
              )
            }
          end
        end
      end
    end
  end
end
