require 'spec_helper'

describe 'afl_crowdstrike::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
        it { is_expected.to contain_class('afl_crowdstrike::config') }
        it { is_expected.to compile }
    end
  end
end
