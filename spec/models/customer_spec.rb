require 'spec_helper'

describe Customer do
  let(:customer) {Customer.create balance: 160}

  it 'is valid with valid attributes' do
    expect(Customer.new).to be_valid
  end

  describe '#deposit' do
    context 'if the amount is more than zero' do
      let(:deposit_amount) { 15 }

      it "increases the customer's balance by the specified amount" do
        customer.deposit! deposit_amount

        expect(customer.balance).to eql 175
      end
    end

    context 'if the amount is less than zero' do
      let(:deposit_amount) { -1 }

      it 'raises an Customer::DepositMustBeGreatThanZero exception' do
        expect{customer.deposit!(deposit_amount)}.to raise_error Customer::DepositMustBeGreaterThanZero
      end
    end
  end

  describe '#calculate_rewards!' do

    context 'when the customer is a gold member' do
      before { customer.stub(:gold_member?).and_return true }

      it 'earns a reward for every 25 bucks they have on their balance' do
        expect(customer).to receive(:reward_earned!).exactly(6).times

        customer.calculate_rewards!
      end
    end

    context 'when the customer is a silver member' do
      before { customer.stub(:gold_member?).and_return false }

      it 'earns a reward for every 50 bucks they have on their balance' do
        expect(customer).to receive(:reward_earned!).exactly(3).times

        customer.calculate_rewards!
      end
    end

    it 'updates the balance, removing the amount equal to the number of rewards received' do
      customer.calculate_rewards!

      expect(customer.balance).to eql 10
    end
  end

  describe '#reward_earned!' do

    it "adds today's date to the array of rewards for a customer" do
      customer = Customer.create balance: 10, rewards: [ Date.yesterday, 1.month.ago.to_date ]

      customer.reward_earned!

      expect(customer.rewards).to eql [ Date.yesterday, 1.month.ago.to_date, Date.today]
    end
  end

  describe '#destination_rewards_link_params' do
    it 'returns a hash of the attributes used for destination rewards link URL' do

      customer = Customer.create( first_name:     'Test',
                                  last_name:      'Man',
                                  program_id:     '1',
                                  buyer_id:       '1',
                                  street:         '123 Test St.',
                                  city:           'Example',
                                  state:          'RI',
                                  zip_code:       '02920',
                                  email_address:  'testman@example.com')


      expect(customer.destination_rewards_link_params).to eql({
                                                                pi:         1,
                                                                user:       1,
                                                                firstname:  'Test',
                                                                lastname:   'Man',
                                                                address:    '123 Test St.',
                                                                city:       'Example',
                                                                state:      'RI',
                                                                country:    'US',
                                                                zip:        '02920',
                                                                email:      'testman@example.com'
                                                             })
    end
  end
end

