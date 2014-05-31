require 'csv'

CSV::HeaderConverters[:weis_header] = lambda do |header|
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

class Enrollment

  def initialize(raw_csv_file)
    @raw_csv_file = raw_csv_file

    @csv_file = ::CSV.open(@raw_csv_file, 'r',  headers:            true,
                                                converters:         :all,
                                                header_converters:  :weis_header)
  end

  def self.process!(raw_csv_file)
    Enrollment.new(raw_csv_file).process!
  end

  def process!
    customers_attributes.each do |customer_attributes|
      customer = Customer.where(id: customer_attributes[:id]).first

      if customer
        customer.update customer_attributes.except(:new_member, :id)
      else
        Customer.create customer_attributes.except(:new_member)
      end
    end
  end

  def customers_attributes
    @csv_file.to_a.map { |customer_row| customer_row.to_hash }
  end
end

