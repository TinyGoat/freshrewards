require 'spec_helper'

describe EnrollmentFile do
  let(:customer_csv) { File.open Rails.root + 'spec/support/fixtures/enrollment.csv' }

  it 'requires a CSV file' do
    expect{EnrollmentFile.new}.to raise_error
    expect{EnrollmentFile.new(customer_csv)}.to_not raise_error
  end

  describe 'self.process!' do
    let(:enrollment) { double(process!: true) }

    before { EnrollmentFile.stub(:new).and_return enrollment }

    it 'creates a new EnrollmentFile with the specificied CSV file' do
      expect(EnrollmentFile).to receive(:new).with(customer_csv)

      EnrollmentFile.process! customer_csv
    end

    it 'called process! on the newly created EnrollmentFile' do
      expect(enrollment).to receive(:process!)

      EnrollmentFile.process! customer_csv
    end
  end

  describe '#process!' do
    context 'when a customer in the CSV does not already exist' do
      it 'creates a new user for each line of the CSV file that was passed in to the EnrollmentFile' do
        enrollment  = EnrollmentFile.new customer_csv

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
        enrollment  = EnrollmentFile.new customer_csv

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
  end
end
