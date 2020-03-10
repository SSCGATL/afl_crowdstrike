# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include afl_crowdstrike::post
class afl_crowdstrike::post {
  case $facts['os']['family'] {
    'Windows': {

    }
    'Darwin': {

    }
    default: {
      notice('foo')
    }
  }
}
