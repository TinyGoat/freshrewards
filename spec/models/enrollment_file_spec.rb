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
    let(:uploader)    { DestinationRewards::RemoteFolder.instance }

    before { uploader.stub(:upload!) }

    context 'when a customer in the CSV does not already exist' do
      it 'creates a new user for each line of the CSV file that was passed in to the EnrollmentFile' do
        enrollment  = EnrollmentFile.new enrollment_csv

        expect(Customer).to receive(:create).once.with  id:                      11,
                                                        password:               'Rewards',
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

        expect(Customer).to receive(:create).once.with  id:                      22,
                                                        password:               'Rewards',
                                                        buyer_id:                2,
                                                        first_name:             'Jane',
                                                        middle_name:            'Mary',
                                                        last_name:              'Doe',
                                                        street:                 '125 Test Ave.',
                                                        city:                   'Warwick',
                                                        state:                  'Rhode Island',
                                                        zip_code:                12886,
                                                        phone_number:            4019460376,
                                                        email_address:          'jane@example.com',
                                                        program_id:              111,
                                                        balance:                 75,
                                                        gold_member:             0

        enrollment.process!
      end
    end

    context 'when a customer in the CSV already exists' do
      let!(:customer) { Customer.create id:            22,
                                        first_name:   'Mary',
                                        middle_name:  'Jane',
                                        last_name:    'Doe',
                                        balance:       50,
                                        gold_member:   false }

      before do
        Customer.stub(:where).and_return double(first: nil)
        Customer.stub(:where).with(id: 22).and_return double(first: customer)
      end

      it 'updates the existing customer with any new information' do
        enrollment  = EnrollmentFile.new enrollment_csv

        expect(Customer).to receive(:create).with id:              11,
                                                  password:       'Rewards',
                                                  buyer_id:        1,
                                                  first_name:     'John',
                                                  middle_name:    'Joseph',
                                                  last_name:      'Doe',
                                                  street:         '123 Test St.',
                                                  city:           'Cranston',
                                                  state:          'Rhode Island',
                                                  zip_code:       12920,
                                                  phone_number:   4015781958,
                                                  email_address: 'john@example.com',
                                                  program_id:     111,
                                                  balance:        100,
                                                  gold_member:    1

        expect(customer).to receive(:update).with password:      'Rewards',
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

        enrollment.process!
      end
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
