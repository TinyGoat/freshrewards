require 'csv'

CSV::HeaderConverters[:enrollment_header] = lambda do |header|
  case header
  when 'InitialDCash'
    :balance
  when 'Gcstatus'
    :gold_member
  when 'UserID'
     :weis_id
  when 'Address'
    :street
  when 'Email'
    :email_address
  else
    header.underscore.to_sym
  end
end

CSV::HeaderConverters[:enrollment_upload_header] = lambda do |header|
  case header
  when 'balance'
    'InitialDCash'
  when 'weis_id'
     'UserID'
  when 'street'
    'Address'
  when 'email_address'
    'Email'
  when 'program_id'
    'ProgramID'
  when 'buyer_id'
    'BuyerID'
  else
    header.camelize
  end
end

class EnrollmentFile

  def initialize(raw_csv_file)
    @raw_csv_file = raw_csv_file

    @csv_file = ::CSV.read(@raw_csv_file, headers:            true,
                                          converters:         :all,
                                          header_converters:  :enrollment_header)
  end

  def self.process!(raw_csv_file)
    self.new(raw_csv_file).process!
  end

  def process!
    process_customers_in_file

    upload_file_to_destination_rewards
  end

  private

  def process_customers_in_file
    customers_attributes.each do |customer_attributes|
      next if customer_attributes.empty?

      customer = Customer.find_or_create_by(weis_id: customer_attributes[:weis_id])

      customer.update customer_attributes.except(:new_member, :weis_id)

      customer.calculate_rewards!
    end
  end

  def upload_file_to_destination_rewards
    remote_folder.upload(as_upload, "#{upload_path}")
  end

  def remote_folder
    DestinationRewards::RemoteFolder.instance
  end

  def as_upload
    @upload_file ||= begin
                      upload_csv = @csv_file

                      upload_csv = CSV.new(upload_csv.to_csv, headers:            true,
                                                              header_converters: :enrollment_upload_header)
                      csv = upload_csv.read()

                      upload_file = Tempfile.new(upload_path)

                      csv.each do |row|
                        next if row.empty?

                        customer = Customer.find_by_weis_id(row['UserID'])

                        row['InitialDCash'] = customer.upload_rewards!
                        row['BuyerID']      = ENV['DR_BUYER_ID']
                        row['ProgramID']    = ENV['DR_PROGRAM_ID']

                        upload_file.write(row.to_s.gsub(',','|'))
                      end

                      upload_file.rewind

                      upload_file
                     end
  end

  def upload_path
    "Weis_Enrollment_#{Date.today.strftime('%m%d%Y')}.csv"
  end

  def customers_attributes
    @csv_file.map { |row| row.to_hash }
  end
end

