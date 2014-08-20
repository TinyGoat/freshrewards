class Transaction
  def initialize(transaction_attributes)
    @transaction_attributes = transaction_attributes
  end

  def self.process!(transaction_attributes)
    self.new(transaction_attributes).process!
  end

  def process!
    if should_deactivate_customer?
      customer.deactive!
    else
      customer.deposit!(deposit_amount)
      customer.calculate_rewards!
    end
  end

  private

  def should_deactivate_customer?
    deposit_amount == -1
  end

  def deposit_amount
    @deposit_amount ||= @transaction_attributes[:deposit_amount]
  end

  def customer
    @customer ||= begin
                    Customer.find_by_weis_id(@transaction_attributes[:user_id])
                  rescue ActiveRecord::RecordNotFound
                    raise CustomerNotFound
                  end
  end

  class CustomerNotFound < ActiveRecord::RecordNotFound; end
end
