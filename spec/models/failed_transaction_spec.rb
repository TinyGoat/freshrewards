require 'spec_helper'

describe FailedTransaction do

  it 'requires a set of transaction attributes' do
    expect{FailedTransaction.new}.to raise_error

    expect{ FailedTransaction.new({ buyer_id:        1,
                                    program_id:      1,
                                    user_id:         1,
                                    deposit_amount:  100,
                                    description:     'Good' })}.to_not raise_error
  end

  describe '#to_partial_path' do
    it 'returns "failed_transaction"' do
      expect(FailedTransaction.new({}).to_partial_path).to eql 'failed_transaction'
    end
  end

  describe '#failure_reason' do
    it 'returns "Customer could not be found"' do
      expect(FailedTransaction.new({}).failure_reason).to eql 'Customer could not be found'
    end
  end
end

