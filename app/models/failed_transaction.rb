class FailedTransaction

  def initialize(transaction_attributes)
    @transaction_attributes = transaction_attributes

  end

  def to_partial_path
    'failed_transaction'
  end

  def failure_reason
    'Customer could not be found'
  end

  #Write an accessor method for each key in the transactions attributes hash
  def method_missing(meth, *args, &block)
    @transaction_attributes[meth] ? @transaction_attributes[meth]: super
  end
end
