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

  def calculate_rewards!
    number_of_rewards_earned = balance/reward_threshold

    number_of_rewards_earned.times { reward_earned! }

    update_attributes(balance:                balance%reward_threshold,
                      rewards_to_be_uploaded: number_of_rewards_earned)
  end

  def reward_earned!
    #ActiveRecord's cache messes up just a normal push to a PG array, we need to tell it
    #to invalidate its cached version of rewards manually
    rewards_will_change!

    update_attributes rewards: rewards.push(Date.today)
  end

  def upload_rewards!
    total_direct_rewards_bucks = rewards_to_be_uploaded * direct_rewards_bucks

    update_attribute(:rewards_to_be_uploaded, 0)

    total_direct_rewards_bucks
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

  def member_status
    gold_member? ? 'Gold' : 'Club'
  end

  def reward_threshold
    250
  end

  def direct_rewards_bucks
    gold_member? ? 50 : 25
  end

  private

  class DepositMustBeGreaterThanZero < StandardError
    def initialize(amount)
      @amount = amount
    end

    def to_s
      "Deposit amount must be greater than 0, in this case it was actually #{@amount}"
    end
  end
end

