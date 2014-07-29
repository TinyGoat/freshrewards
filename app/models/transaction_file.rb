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

CSV::HeaderConverters[:transaction_upload_header] = lambda do |header|
  case header
  when 'deposit_amount'
    'RewardsCash'
  when 'description'
    'TXN Description'
  when 'program_id'
    'ProgramID'
  when 'buyer_id'
    'BuyerID'
  when 'user_id'
    'UserID'
  else
    header.camelize
  end
end

class TransactionFile

  def initialize(csv_file)
    @raw_csv_file        = csv_file
    @failed_transactions = []

    @csv_file = ::CSV.read(@raw_csv_file, headers:            true,
                                          converters:         :all,
                                          header_converters:  :transaction_header)
  end

  attr_reader :failed_transactions

  def self.process!(csv_file)
    self.new(csv_file).process!
  end

  def process!
    process_transactions_in_file

    upload_file_to_destination_rewards

    self
  end

  def successful?
    failed_transactions.empty?
  end

  private

  def process_transactions_in_file
    transactions_data.each do |transaction_data|
      begin
        Transaction.process! transaction_data
      rescue Transaction::CustomerNotFound
        failed_transactions << FailedTransaction.new(transaction_data)
      end
    end
  end

  def upload_file_to_destination_rewards
    remote_folder.upload(as_upload, "/weis/#{upload_path}")
  end

  def remote_folder
    DestinationRewards::RemoteFolder.instance
  end

  def as_upload
    @upload_file ||= begin
                      upload_csv = @csv_file

                      upload_csv = CSV.new(upload_csv.to_csv, headers:            true,
                                                              header_converters: :transaction_upload_header)

                      csv = upload_csv.read()

                      upload_file = Tempfile.new(upload_path)

                      csv.each do |row|
                        next if row.empty?

                        customer = Customer.find(row['UserID'])

                        row['RewardsCash'] = customer.upload_rewards!

                        upload_file.write(row.to_s.gsub(',','|'))
                      end

                      upload_file.rewind

                      upload_file
                     end
  end

  def upload_path
    "Weis_Transaction_#{Date.today.strftime('%m%d%Y')}.csv"
  end

  def transactions_data
    @csv_file.map { |row| row.to_hash }
  end
end
