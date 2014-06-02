require 'spec_helper'

describe Profile do
  let(:customer) { double}
  let(:profile)  { Profile.new(customer) }

  it 'requires a customer' do
    expect{ Profile.new}.to raise_error
    expect{ Profile.new(double('Customer'))}.to_not raise_error
  end

  describe '#current_reward_progress' do

    it "returns the customer's current balance" do
      customer.stub(:balance).and_return 65

      expect(profile.current_reward_progress).to eql 65
    end
  end

  describe '#amount_remaining_for_current_reward' do

    it "returns the difference between the customer's current balance and 75" do
      customer.stub(:balance).and_return 65

      expect(profile.amount_remaining_for_current_reward).to eql 10
    end
  end

  describe '#rewards_count' do
    it 'returns the number of rewards the customer has earned so far' do
      customer.stub(:rewards).and_return [double, double, double]

      expect(profile.rewards_count).to eql 3
    end
  end

  describe '#full_name' do

    it 'returns the first and last name of the customer' do
      customer.stub(:first_name).and_return 'Jon'
      customer.stub(:last_name).and_return 'Smith'

      expect(profile.full_name).to eql 'Jon Smith'
    end
  end

  describe '#street' do

    it 'returns the street address for the customer' do
      customer.stub(:street).and_return '123 Test St.'

      expect(profile.street).to eql '123 Test St.'
    end
  end

  describe '#city_state_zip_code' do

    it "returns the customer's city state and zip as one string" do
      customer.stub(:city).and_return 'Cranston'
      customer.stub(:state).and_return 'Rhode Island'
      customer.stub(:zip_code).and_return '02920'

      expect(profile.city_state_zip_code).to eql 'Cranston, Rhode Island 02920'
    end
  end

  describe '#phone_number' do

    it 'returns the phone number for the customer formatted as XXX-XXX-XXXX' do
      customer.stub(:phone_number).and_return '4019460376'

      expect(profile.phone_number).to eql '401-946-0376'
    end
  end

  describe '#email_address' do

    it 'returns the email address for the customer' do
      customer.stub(:email_address).and_return 'jon@example.com'

      expect(profile.email_address).to eql 'jon@example.com'
    end
  end

  describe '#rewards' do

    it 'returns an array of reward dates for the customer in the format June 1, 2014' do
      date = Date.parse('14-05-15') # May 15, 2014

      Timecop.travel date do
        customer.stub(:rewards).and_return [ 1.month.ago.to_date, Date.yesterday]

        expect(profile.rewards).to eql [ 'April 15, 2014', 'May 14, 2014']
      end
    end
  end
end


