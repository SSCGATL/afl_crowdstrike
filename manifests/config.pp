# @summary Manifest to supply ad-hoc configuration parameters to
# the target system
#

class afl_crowdstrike::config {

  case $facts['os']['family'] {
    'Windows': {

    }
    'Darwin': {

    }
    default: {
      notify('foo')
    }
  }
}
