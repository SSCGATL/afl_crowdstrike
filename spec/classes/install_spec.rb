require 'spec_helper'

describe 'afl_crowdstrike::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'afl_crowdstrike' }
        it { is_expected.to contain_class('afl_crowdstrike::install') }
        it { is_expected.to compile }
      describe 'afl_crowdstrike::install', type: :class do
        describe 'On Windows' do
          let(:facts) do
            {
              kernel: 'windows',
              operatingsystem: 'TestOS',
              operatingsystemrelease: 5,
              osfamily: 'windows',
              os: { family: 'windows' },
              architecture: 'x64',
              processor0: 'intel_awesome',
              fqdn: 'test.example.com',
              ipaddress: '123.23.243.1',
              memorysize: '16.00 GB',
            }
          end
            before :each do
              Puppet::Util::Platform.stubs(:windows?).returns true
            end
          it do
            is_expected.to contain_archive('C:/Windows/TEMP/WindowsSensor.exe').with(
              ensure:  'present',
              source:  's3://puppets3bucket/WindowsSensor.exe',
              creates: 'C:/Windows/TEMP/WindowsSensor.exe',
              cleanup: false,
            )
          end
          it do
            is_expected.to contain_package('CrowdStrike').with(
          ensure: 'present',
          source: 'C:/Windows/TEMP/WindowsSensor.exe',
          install_options: [ '/install', '/quiet', '/norestart', 'CID=39682F0156CF4F67B274E35F0FE9EFF3-12'],
            ).that_requires('Archive[C:/Windows/TEMP/WindowsSensor.exe]')
          end
          it do
            is_expected.to contain_registry_key('HKLM\SYSTEM\CrowdStrike\{9b03c1d9-3138-44ed-9fae-d9f4c034b88d}{16e0423f-7058-48c9-a204-725362b67639}').with(
              ensure: 'present',
            )
          end
          it do
            is_expected.to contain_registry_value('Default GroupingTags').with(
              ensure: 'present',
              type:   'string',
              data:   'Puppet_Beta_Test',
              path:   'HKLM\SYSTEM\CrowdStrike\{9b03c1d9-3138-44ed-9fae-d9f4c034b88d}{16e0423f-7058-48c9-a204-725362b67639}',
            )
          end
        end
        describe 'On Darwin' do
          let(:facts) do
            {
              kernel: 'Darwin',
              operatingsystem: 'Darwin',
              operatingsystemrelease: '19.0.0',
              osfamily: 'Darwin',
              os: { family: 'Darwin' },
              architecture: 'x86_64',
              processor0: 'intel_awesome',
              fqdn: 'test.example.com',
              ipaddress: '123.23.243.1',
              memorysize: '8.00 GB',
            }
          end

          it do
            is_expected.to contain_archive('/var/tmp/FalconSensorMacOS.pkg').with(
              ensure: 'present',
              source: 's3://puppets3bucket/FalconSensorMacOS.pkg',
              creates: '/var/tmp/FalconSensorMacOS.pkg',
              cleanup: false,
            )
          end
          it do
            is_expected.to contain_package('FalconSensorMacOS').with(
              ensure: 'present',
              provider: 'apple',
              source: '/var/tmp/FalconSensorMacOS.pkg',
            ).that_requires('Archive[/var/tmp/FalconSensorMacOS.pkg]')
          end
        end
      end
    end
  end
end
