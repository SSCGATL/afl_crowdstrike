# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include afl_crowdstrike
class afl_crowdstrike {

  include afl_crowdstrike::config
  include afl_crowdstrike::install
  include afl_crowdstrike::post

  Class['afl_crowdstrike::install']
  -> Class['afl_crowdstrike::config']
  -> Class['afl_crowdstrike::post']

}
