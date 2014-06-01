require 'acceptance/helper'

feature 'Administrator imports transaction file', %q{
  As an administrator
  So that I can easily update the Rewards balances for customers in the FreshRewards program
  I want to import a transactions file which has current spending total for existing customers } do

  scenario 'Administrator successfully imports transactions file ' do
    create_existing_customers

    upload_new_transaction_file

    confirm_redirect_and_flash_notice

    confirm_customer_balances_were_updated
  end

  scenario 'Administrator imports file containing customers not in the system' do
    upload_new_transaction_file

    confirm_error_page_rendered
  end

  def create_existing_customers
    Customer.create(id: 1, email_address: 'john@example.com', password: 'Rewards', balance: 15)
    Customer.create(id: 2, email_address: 'jane@example.com', password: 'Rewards', balance: 25)
  end

  def upload_new_transaction_file
    visit       'admin/transaction/new'
    attach_file 'Transaction CSV', Rails.root + 'spec/support/fixtures/transaction.csv'
    click_on    'Upload transaction'
  end

  def confirm_redirect_and_flash_notice
    expect(page.current_path).to eql new_admin_transaction_path

    confirm_flash_contains 'You transaction file was processed successfully'
  end

  def confirm_flash_contains(text)
    expect(page.find('#flash_notice')).to have_text text
  end

  def confirm_customer_balances_were_updated
    expect(Customer.find(1).balance).to eql 115
    expect(Customer.find(2).balance).to eql 225
  end

  def confirm_error_page_rendered
    expect(page).to have_text 'Not all customers in the transaction file were found in the system'

    expect(page).to have_css '.failed-transaction', count: 2
  end
end

