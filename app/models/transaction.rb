class Transaction
  def initialize(transaction_attributes)
    @transaction_attributes = transaction_attributes
  end

  def self.process!(transaction_attributes)
    self.new(transaction_attributes).process!
  end

  def process!
    should_deactivate_customer? ? customer.deactive! : customer.deposit!(deposit_amount)
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
                    Customer.find(@transaction_attributes[:user_id])
                  rescue ActiveRecord::RecordNotFound
                    raise CustomerNotFound
                  end
  end

  class CustomerNotFound < ActiveRecord::RecordNotFound; end
end
