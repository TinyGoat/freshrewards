require 'spec_helper'

describe Admin::TransactionsController do

  describe '#new' do
    it "renders the 'new' template" do
      get :new

      expect(response).to render_template 'new'
    end
  end

  describe '#create' do
    let(:csv_file)      { File.open Rails.root + 'spec/support/fixtures/transaction.csv' }
    let(:file_upload)   { ActionDispatch::Http::UploadedFile.new(filename: 'transaction.csv',
                                                                 type:     'text/csv',
                                                                 tempfile:  csv_file)}
    it 'processes a new Transaction' do
      expect(TransactionFile).to receive(:process!).with(csv_file)
                                                   .and_return double(successful?: true)

      post :create, transaction_file: file_upload
    end

    context 'when the processing of the transaction file succeeds' do
      before { TransactionFile.stub(:process!).and_return double(successful?: true) }

      it 'redirects to the new transaction form' do

        post :create, transaction_file: file_upload

        expect(response).to redirect_to new_admin_transaction_path
      end
    end

    context 'when the processing of the transaction file had some transactions that could not '\
            'be completed successfully' do

      let(:failed_transactions) { [ 'failed-transactions'] }

      before { TransactionFile.stub(:process!)
                              .and_return double(successful?:         false,
                                                 failed_transactions: failed_transactions) }

      it 'assigns the failed transactions to the view' do
        post :create, transaction_file: file_upload

        expect(assigns(:failed_transactions)).to eql failed_transactions
      end

      it 'renders the create template' do
        post :create, transaction_file: file_upload

        expect(response).to render_template 'create'
      end
    end
  end
end

