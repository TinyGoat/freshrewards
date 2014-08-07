class Admin::TransactionsController < Admin::BaseController
  layout 'admin'

  def new

  end

  def create
    transaction_file = TransactionFile.process! params[:transaction_file].tempfile

    if transaction_file.successful?
      redirect_to new_admin_transaction_path, notice: 'You transaction file was processed successfully'
    else
      @failed_transactions = transaction_file.failed_transactions

      render :create
    end
  end
end
