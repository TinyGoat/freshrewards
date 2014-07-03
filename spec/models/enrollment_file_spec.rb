require 'spec_helper'

describe EnrollmentFile do
  let(:enrollment_csv) { File.open Rails.root + 'spec/support/fixtures/enrollment.csv' }

  it 'requires a CSV file' do
    expect{EnrollmentFile.new}.to raise_error
    expect{EnrollmentFile.new(enrollment_csv)}.to_not raise_error
  end

  describe 'self.process!' do
    let(:enrollment) { double(process!: true) }

    before { EnrollmentFile.stub(:new).and_return enrollment }

    it 'creates a new EnrollmentFile with the specificied CSV file' do
      expect(EnrollmentFile).to receive(:new).with(enrollment_csv)

      EnrollmentFile.process! enrollment_csv
    end

    it 'called process! on the newly created EnrollmentFile' do
      expect(enrollment).to receive(:process!)

      EnrollmentFile.process! enrollment_csv
    end
  end

  describe '#process!' do
    let(:uploader)        { DestinationRewards::RemoteFolder.instance }
    let(:customer)        { double(update: true, calculate_rewards!: true )}
    let(:enrollment_file) { EnrollmentFile.new(enrollment_csv) }

    before do
      uploader.stub(:upload!)
      Customer.stub(:find_or_create_by).and_return customer
    end

    it "either finds or creates a new customer based on the customer's id" do
      expect(Customer).to receive(:find_or_create_by).once.with(id: 11).and_return customer
      expect(Customer).to receive(:find_or_create_by).once.with(id: 22).and_return customer

      enrollment_file.process!
    end

    it 'updates the customer with the customer attributes, except the id and new_member statues' do
      expect(customer).to receive(:update).once.with  password:               'Rewards',
                                                      buyer_id:                1,
                                                      first_name:             'John',
                                                      middle_name:            'Joseph',
                                                      last_name:              'Doe',
                                                      street:                 '123 Test St.',
                                                      city:                   'Cranston',
                                                      state:                  'Rhode Island',
                                                      zip_code:                12920,
                                                      phone_number:            4015781958,
                                                      email_address:          'john@example.com',
                                                      program_id:              111,
                                                      balance:                 100,
                                                      gold_member:             1

      expect(customer).to receive(:update).once.with  password:      'Rewards',
                                                      buyer_id:       2,
                                                      first_name:    'Jane',
                                                      middle_name:   'Mary',
                                                      last_name:     'Doe',
                                                      street:        '125 Test Ave.',
                                                      city:          'Warwick',
                                                      state:         'Rhode Island',
                                                      zip_code:       12886,
                                                      phone_number:   4019460376,
                                                      email_address: 'jane@example.com',
                                                      program_id:     111,
                                                      balance:        75,
                                                      gold_member:    0

      enrollment_file.process!
    end

    it 'calculates the rewards for the customer' do
      expect(customer).to receive(:calculate_rewards!)

      enrollment_file.process!
    end

    it 'uploads the file to Destination Rewards SFTP folder' do

      Date.stub(:today).and_return Date.new(2014,05,14)

      enrollment  = EnrollmentFile.new enrollment_csv

      expect(uploader).to receive(:upload!).with enrollment.send(:as_upload),
                                                 '/Weis_Enrollment_05142014.csv'

      enrollment.process!
    end
  end

  describe '#as_upload' do
    let(:enrollment_file) { EnrollmentFile.new(enrollment_csv) }

    it 'removes the last two columns from the original CSV file' do
      expect(enrollment_file.send(:as_upload).read.headers).to_not include 'Gcstatus', 'NewMember'
    end

    it 'converts the headers to camelcase' do
      expect(enrollment_file.send(:as_upload).read.headers).to include("BuyerId", "UserID", "Password",
                                                                "FirstName", "MiddleName", "LastName",
                                                                "Address", "City", "State", "ZipCode",
                                                                "PhoneNumber", "Email", "ProgramID",
                                                                "InitialDCash")
    end

    it 'returns the new CSV file' do
      expect(enrollment_file.send(:as_upload)).to be_an_instance_of CSV
    end
  end
end
