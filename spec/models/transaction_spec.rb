require 'spec_helper'

describe Transaction do
  let(:transaction_attributes) {{ buyer_id:        1,
                                  program_id:      1,
                                  user_id:         1,
                                  deposit_amount:  100,
                                  description:     'Good' }}

  it 'requires a set of attributes' do
    expect{ Transaction.new}.to raise_error

    expect{ Transaction.new(transaction_attributes)}.to_not raise_error
  end

  describe 'self.process!' do
    let(:transaction) { double(process!: true) }

    before { Transaction.stub(:new).and_return transaction }

    it 'creates a new Transaction with the specificied CSV file' do
      expect(Transaction).to receive(:new).with(transaction_attributes)

      Transaction.process! transaction_attributes
    end

    it 'called process! on the newly created Transaction' do
      expect(transaction).to receive(:process!)

      Transaction.process! transaction_attributes
    end
  end

  describe '#process!' do
    let(:transaction) { Transaction.new transaction_attributes }
    let(:customer)    { Customer.create balance: 10 }

    before { Customer.stub(:find).and_return customer }

    it "finds the Customer associated with the user id specificed in its attributes" do
      expect(Customer).to receive(:find).with 1

      transaction.process!
    end

    context 'when a Customer associated with that id can not be found' do
      before { Customer.stub(:find).and_raise ActiveRecord::RecordNotFound }

      it 'raises a Transaction::CustomerNotFound exception' do
        expect{transaction.process!}.to raise_error Transaction::CustomerNotFound
      end
    end

    context 'when the deposit amount is 0 or greater' do
      before { transaction.stub(:deposit_amount).and_return 1 }

      it "makes a deposit for the customer" do
        expect(customer).to receive(:deposit!).with 1

        transaction.process!
      end
    end

    context 'when the deposit amount is -1' do
      before { transaction.stub(:deposit_amount).and_return(-1) }

      it "deactivates the customer's account" do
        expect(customer).to receive(:deactive!)

        transaction.process!
      end
    end
  end
end
