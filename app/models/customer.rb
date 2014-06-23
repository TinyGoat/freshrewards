class Customer < ActiveRecord::Base
  acts_as_paranoid column: :deactivated_at

  alias :deactivated? :destroyed?
  alias :deactivate!  :destroy!
  alias :activate!    :restore!

  def deposit!(amount)
    if amount > 0
     update(balance: balance + amount)
    else
      raise DepositMustBeGreaterThanZero.new(amount)
    end
  end

  def reward_earned!
    #ActiveRecord's cache messes up just a normal push to a PG array, we need to tell it
    #to invalidate its cached version of rewards manually
    rewards_will_change!

    update_attributes rewards: rewards.push(Date.today)
  end

  def destination_rewards_link_params
    {
      pi:         program_id,
      user:       buyer_id,
      firstname:  first_name,
      lastname:   last_name,
      address:    street,
      city:       city,
      state:      state,
      country:    'US',
      zip:        zip_code,
      email:      email_address
    }
  end

  class DepositMustBeGreaterThanZero < StandardError
    def initialize(amount)
      @amount = amount
    end

    def to_s
      "Deposit amount must be greater than 0, in this case it was actually #{@amount}"
    end
  end
end

