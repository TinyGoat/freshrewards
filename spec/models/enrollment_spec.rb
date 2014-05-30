require 'spec_helper'

describe Enrollment do
  let(:customer_csv) { File.open Rails.root + 'spec/support/fixtures/enrollment.csv' }

  it 'requires a CSV file' do
    expect{Enrollment.new}.to raise_error
    expect{Enrollment.new(customer_csv)}.to_not raise_error
  end

  describe 'self.process!' do
    let(:enrollment) { double(process!: true) }

    before { Enrollment.stub(:new).and_return enrollment }

    it 'creates a new Enrollment with the specificied CSV file' do
      expect(Enrollment).to receive(:new).with(customer_csv)

      Enrollment.process! customer_csv
    end

    it 'called process! on the newly created Enrollment' do
      expect(enrollment).to receive(:process!)

      Enrollment.process! customer_csv
    end
  end

  describe '#process!' do
    it 'creates a new user for each line of the CSV file that was passed in to the Enrollment' do
      enrollment  = Enrollment.new customer_csv

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
                                                      gold_member:             1

      enrollment.process!
    end
  end
end
