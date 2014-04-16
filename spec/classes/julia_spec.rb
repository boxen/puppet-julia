require 'spec_helper'

describe 'julia' do
  it do
    should contain_package('Julia').with({
      :source   => 'https://s3.amazonaws.com/julialang/bin/osx/x64/0.2/julia-0.2.1-osx10.7+.dmg',
      :provider => 'appdmg'
    })
  end
end
