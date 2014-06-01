require 'csv'

CSV::HeaderConverters[:transaction_header] = lambda do |header|
  case header
  when 'RewardsCash'
    :deposit_amount
  when 'TXN Description'
    :description
  else
    header.underscore.to_sym
  end
end

class TransactionFile

  def initialize(csv_file)
    @raw_csv_file        = csv_file
    @failed_transactions = []

    @csv_file = ::CSV.open(@raw_csv_file, 'r',  headers:            true,
                                                converters:         :all,
                                                header_converters:  :transaction_header)
  end

  attr_reader :failed_transactions

  def self.process!(csv_file)
    self.new(csv_file).process!
  end

  def process!
    transactions_data.each do |transaction_data|
      begin
        Transaction.process! transaction_data
      rescue Transaction::CustomerNotFound
        failed_transactions << FailedTransaction.new(transaction_data)
      end
    end

    self
  end

  def successful?
    failed_transactions.empty?
  end

  private

  def transactions_data
    @csv_file.to_a.map { |transaction_row| transaction_row.to_hash }
  end
end
