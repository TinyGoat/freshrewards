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
    @raw_csv_file = csv_file

    @csv_file = ::CSV.open(@raw_csv_file, 'r',  headers:            true,
                                                converters:         :all,
                                                header_converters:  :transaction_header)
  end

  def self.process!(csv_file)
    self.new(csv_file).process!
  end

  def process!
    transactions_data.each { |transaction_data| Transaction.process! transaction_data }
  end

  private

  def transactions_data
    @csv_file.to_a.map { |transaction_row| transaction_row.to_hash }
  end
end
