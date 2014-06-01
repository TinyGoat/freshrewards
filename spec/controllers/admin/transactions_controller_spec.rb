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
      expect(TransactionFile).to receive(:process!).with csv_file

      post :create, transaction_file: file_upload
    end

    it 'redirects to the new transaction form' do
      TransactionFile.stub(:process!).and_return true

      post :create, transaction_file: file_upload

      expect(response).to redirect_to new_admin_transaction_path
    end
  end
end

