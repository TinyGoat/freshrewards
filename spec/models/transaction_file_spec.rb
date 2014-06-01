require 'spec_helper'

describe TransactionFile do
  let(:transaction_csv) { File.open Rails.root + 'spec/support/fixtures/transaction.csv' }

  it 'requires a CSV file' do
    expect{TransactionFile.new}.to raise_error
    expect{TransactionFile.new(transaction_csv)}.to_not raise_error
  end

  describe 'self.process!' do
    let(:transaction) { double(process!: true) }

    before { TransactionFile.stub(:new).and_return transaction }

    it 'creates a new TransactionFile with the specificied CSV file' do
      expect(TransactionFile).to receive(:new).with(transaction_csv)

      TransactionFile.process! transaction_csv
    end

    it 'called process! on the newly created TransactionFile' do
      expect(transaction).to receive(:process!)

      TransactionFile.process! transaction_csv
    end
  end

  describe '#process!' do

    it 'creates a new Transaction for each line of the TransactionFile' do
      Transaction.stub(:process!)


      expect(Transaction).to receive(:process!).once.with( buyer_id:        1,
                                                           program_id:      1,
                                                           user_id:         1,
                                                           deposit_amount:  100,
                                                           description:     'Bought some cool stuff' )

      expect(Transaction).to receive(:process!).once.with( buyer_id:        2,
                                                           program_id:      1,
                                                           user_id:         2,
                                                           deposit_amount:  200,
                                                           description:     'Bought some big items' )
      TransactionFile.process! transaction_csv
    end
  end
end

