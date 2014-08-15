class Profile

  def initialize(customer)
    @customer = customer
  end

  attr_reader :customer
  delegate :id, to: :customer

  def current_reward_progress
    @customer.balance
  end

  def amount_remaining_for_current_reward
    reward_threshold - current_reward_progress
  end

  def reward_threshold
    @customer.reward_threshold
  end

  def rewards_count
    @customer.rewards.size
  end

  def full_name
    [@customer.first_name, @customer.last_name].join(' ')
  end

  def first_name
    @customer.first_name
  end

  def street
    @customer.street
  end

  def city_state_zip_code
    [city_and_state, @customer.zip_code].join(' ')
  end

  def phone_number
    [area_code, exchange, subscriber_number].join('-')
  end

  def email_address
    @customer.email_address
  end

  def rewards
    @customer.rewards.map { |date| date.strftime('%B %d, %Y') }
  end

  def member_status
    @customer.gold_member? ? 'Gold' : 'Club'
  end

  private

  def area_code
    @customer.phone_number[0..2]
  end

  def exchange
    @customer.phone_number[3..5]
  end

  def subscriber_number
    @customer.phone_number[6..9]
  end

  def city_and_state
    [@customer.city, @customer.state].join(', ')
  end
end

