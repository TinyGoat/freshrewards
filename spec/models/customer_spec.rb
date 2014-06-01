require 'spec_helper'

describe Customer do

  it 'is valid with valid attributes' do
    expect(Customer.new).to be_valid
  end

  describe '#deposit' do
    let(:customer) {Customer.create balance: 10}

    context 'if the amount is more than zero' do
      let(:deposit_amount) { 15 }

      it "increases the customer's balance by the specified amount" do
        customer.deposit! deposit_amount

        expect(customer.balance).to eql 25
      end
    end

    context 'if the amount is less than zero' do
      let(:deposit_amount) { -1 }

      it 'raises an Customer::DepositMustBeGreatThanZero exception' do
        expect{customer.deposit!(deposit_amount)}.to raise_error Customer::DepositMustBeGreaterThanZero
      end
    end
  end
end

