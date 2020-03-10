# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include afl_crowdstrike::install
class afl_crowdstrike::install {

  case $facts['os']['family'] {
    'Windows': {

      # Retrieve the package from S3
      archive { 'C:/Windows/TEMP/WindowsSensor.exe':
        ensure  => 'present',
        source  => 's3://puppets3bucket/WindowsSensor.exe',
        creates => 'C:/Windows/TEMP/WindowsSensor.exe',
        cleanup => false,
      }

      # Install the CrowdStrike MSI Installer
      package { 'CrowdStrike':
        ensure          => 'present',
        source          => 'C:/Windows/TEMP/WindowsSensor.exe',
        install_options => [
          '/install',
          '/quiet',
          '/norestart',
          'CID=39682F0156CF4F67B274E35F0FE9EFF3-12',
        ],
        require         => Archive['C:/Windows/TEMP/WindowsSensor.exe'],
      }

      # Modify the registry for the Install
      registry_key { 'HKLM\SYSTEM\CrowdStrike\{9b03c1d9-3138-44ed-9fae-d9f4c034b88d}{16e0423f-7058-48c9-a204-725362b67639}':
        ensure => 'present',
      }

      registry_value { 'Default GroupingTags':
        ensure  => 'present',
        type    => 'string',
        data    => 'Puppet_Beta_Test',
        path    => 'HKLM\SYSTEM\CrowdStrike\{9b03c1d9-3138-44ed-9fae-d9f4c034b88d}{16e0423f-7058-48c9-a204-725362b67639}',
        require => Registry_key['HKLM\SYSTEM\CrowdStrike\{9b03c1d9-3138-44ed-9fae-d9f4c034b88d}{16e0423f-7058-48c9-a204-725362b67639}'],
      }

    }
    'Darwin': {

      # Retrieve the Package from S3
      archive { '/var/tmp/FalconSensorMacOS.pkg':
        ensure  => 'present',
        source  => 's3://puppets3bucket/FalconSensorMacOS.pkg',
        creates => '/var/tmp/FalconSensorMacOS.pkg',
        cleanup => false,
      }

      # Install the package from the retrieved file
      package { 'FalconSensorMacOS':
        ensure   => 'present',
        provider => 'apple',
        source   => '/var/tmp/FalconSensorMacOS.pkg',
        require  => Archive['/var/tmp/FalconSensorMacOS.pkg'],
      }
    }
    default: {
    }
  }
}
