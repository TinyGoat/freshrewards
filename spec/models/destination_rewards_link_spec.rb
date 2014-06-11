require 'spec_helper'

describe DestinationRewardsLink do

  it 'accepts a customer' do
    expect{DestinationRewardsLink.new}.to raise_error
    expect{DestinationRewardsLink.new(double('Customer'))}.to_not raise_error
  end

  describe '#as_url' do
    it 'returns URL that follows the DR_Integrated_Login_Methods_2012 document' do
      Time.stub(:now).and_return double(to_i: 1)
      ENV['DR_LOGIN_SECRET'] = '1'

      customer = double( buyer_id:                        '1',
                         destination_rewards_link_params: { test: 'foo' })

      expect(DestinationRewardsLink.new(customer).as_url).to(
         eql 'https://destinationrewards.com/gateway?t=ilogin&bi=619&password=698d51a19d8a121ce581499d7b701668&ts=1&test=foo/')
    end
  end
end

