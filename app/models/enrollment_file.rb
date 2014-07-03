require 'csv'

CSV::HeaderConverters[:enrollment_header] = lambda do |header|
  case header
  when 'InitialDCash'
    :balance
  when 'Gcstatus'
    :gold_member
  when 'UserID'
     :id
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
  when 'id'
     'UserID'
  when 'street'
    'Address'
  when 'email_address'
    'Email'
  when 'program_id'
    'ProgramID'
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
      customer = Customer.find_or_create_by(id: customer_attributes[:id])

      customer.update customer_attributes.except(:new_member, :id)

      customer.calculate_rewards!
    end
  end

  def upload_file_to_destination_rewards
    remote_folder.upload!(as_upload, upload_path)
  end

  def remote_folder
    DestinationRewards::RemoteFolder.instance
  end

  def as_upload
    upload_csv = @csv_file

    upload_csv.delete(:gold_member)
    upload_csv.delete(:new_member)

    @upload_csv ||= CSV.new(upload_csv.to_csv, headers: true,
                                               header_converters: :enrollment_upload_header)
  end

  def upload_path
    "/Weis_Enrollment_#{Date.today.strftime('%m%d%Y')}.csv"
  end

  def customers_attributes
    @csv_file.map { |row| row.to_hash }
  end
end

