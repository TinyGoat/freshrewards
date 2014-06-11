require 'addressable/template'
require 'digest'

class DestinationRewardsLink

  BusinessID = 619

  def initialize(customer)
    @customer = customer
  end

  attr_reader :customer

  def as_url
    Addressable::Template.new("#{base_url}{?query*}/").expand(params).to_s
  end

  private

  def base_url
    "https://destinationrewards.com/gateway"
  end

  def params
    {
      query: {
              t:          'ilogin',
              bi:         BusinessID,
              password:   password,
              ts:         timestamp
             }.merge(customer.destination_rewards_link_params)
    }
  end

  def password
    Digest::MD5.new.update(ENV['DR_LOGIN_SECRET'].to_s + customer.buyer_id.to_s + timestamp).hexdigest
  end

  def timestamp
    @timestamp ||= Time.now.to_i.to_s
  end
end
