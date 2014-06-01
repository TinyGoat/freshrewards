class Customer < ActiveRecord::Base

  def deposit!(amount)
    if amount > 0
     update(balance: balance + amount)
    else
      raise DepositMustBeGreaterThanZero.new(amount)
    end
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

