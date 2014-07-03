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
    let(:transaction_file) { TransactionFile.new(transaction_csv) }
    let(:uploader)    { DestinationRewards::RemoteFolder.instance }

    before { uploader.stub(:upload!) }

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
      transaction_file.process!
    end

    context 'when one of the transactions in the file references a customer that does not exist '\
            'in the system' do

      before { Transaction.stub(:process!).and_raise Transaction::CustomerNotFound }

      it 'creates a failed transaction' do

        expect(FailedTransaction).to receive(:new).once.with(buyer_id:        1,
                                                             program_id:      1,
                                                             user_id:         1,
                                                             deposit_amount:  100,
                                                             description:     'Bought some cool stuff' )

        expect(FailedTransaction).to receive(:new).once.with(buyer_id:        2,
                                                             program_id:      1,
                                                             user_id:         2,
                                                             deposit_amount:  200,
                                                             description:     'Bought some big items' )
        transaction_file.process!
      end

      it 'stores the failed transaction in its failed transactions collection' do
        transaction_file.process!

        expect(transaction_file.failed_transactions.size).to eql 2
      end
    end

    it 'uploads the file to Destination Rewards SFTP folder' do

      Date.stub(:today).and_return Date.new(2014,05,14)

      expect(uploader).to receive(:upload!).with transaction_file.send(:as_upload),
                                                 '/Weis_Transaction_05142014.csv'

      transaction_file.process!
    end
  end

  describe '#as_upload' do
    let(:transaction_file) { TransactionFile.new(transaction_csv) }

    it 'converts the headers to camelcase' do
      expect(transaction_file.send(:as_upload).read.headers).to include("BuyerID", "ProgramID",
                                                                        "UserID", "RewardsCash",
                                                                        "TXN Description")
    end

    it 'returns the new CSV file' do
      expect(transaction_file.send(:as_upload)).to be_an_instance_of CSV
    end
  end

  describe '#successful?' do
    let(:transaction_file) { TransactionFile.new(transaction_csv) }

    it 'returns true if the transaction file has no failed transactions' do
      transaction_file.stub(:failed_transactions).and_return []

      expect(transaction_file).to be_successful
    end

    it 'returns false if the transaction file has some failed transactions' do
      transaction_file.stub(:failed_transactions).and_return [FailedTransaction.new({})]

      expect(transaction_file).to_not be_successful
    end
  end
end

