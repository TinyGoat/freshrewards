class Admin::TransactionsController < ActionController::Base

  def new

  end

  def create
    TransactionFile.process! params[:transaction_file].tempfile

    redirect_to new_admin_transaction_path, notice: 'You transaction file was processed successfully'
  end
end
