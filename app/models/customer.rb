class Customer < ActiveRecord::Base

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

  class DepositMustBeGreaterThanZero < StandardError
    def initialize(amount)
      @amount = amount
    end

    def to_s
      "Deposit amount must be greater than 0, in this case it was actually #{@amount}"
    end
  end
end

