require 'acceptance/helper'

feature 'Customer views profile page', %q{
  As an customer
  So that I can quickly see my FreshRewards status
  I want to be able to view a profile page for my account which summarizies my activity } do

  scenario 'Customer views profile page' do
    @customer = create_customer

    visit profile_path

    expect(page).to have_css '#profile'
  end

  def create_customer
    Customer.create id:             11,
                    password:       'Rewards',
                    buyer_id:       1,
                    first_name:     'John',
                    middle_name:    'Joseph',
                    last_name:      'Doe',
                    street:         '123 Test St.',
                    city:           'Cranston',
                    state:          'Rhode Island',
                    zip_code:       12920,
                    phone_number:   4015781958,
                    email_address:  'john@example.com',
                    program_id:     111,
                    balance:        100,
                    gold_member:    1

  end
end

