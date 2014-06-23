require 'acceptance/helper'

feature 'Administrator imports enrollment file', %q{
  As an administrator
  So that I can easily add new members to the Fresh Rewards program
  I want to be able import an enrollment file which has many users to be added to the program } do

  scenario 'Administrator successfully imports enrollment file ' do
    upload_new_enrollment_file

    confirm_redirect_and_flash_notice

    confirm_customers_were_created
  end

  def upload_new_enrollment_file
    visit       'admin/enrollment/new'
    attach_file 'Enrollment CSV', Rails.root + 'spec/support/fixtures/enrollment.csv'
    click_on    'Upload enrollment'
  end

  def confirm_redirect_and_flash_notice
    expect(page.current_path).to eql new_admin_enrollment_path

    expect(page.find('#flash_notice')).to have_text 'You enrollment file was processed successfully'
  end

  def confirm_customers_were_created
    expect(Customer.find(11)
                   .attributes.with_indifferent_access).to include first_name:     'John',
                                                                   middle_name:    'Joseph',
                                                                   last_name:      'Doe',
                                                                   street:         '123 Test St.',
                                                                   city:           'Cranston',
                                                                   state:          'Rhode Island',
                                                                   zip_code:       '12920',
                                                                   phone_number:   '4015781958',
                                                                   email_address:  'john@example.com',
                                                                   gold_member:     true,
                                                                   balance:         0

    expect(Customer.find(22)
                   .attributes.with_indifferent_access).to include first_name:     'Jane',
                                                                   middle_name:    'Mary',
                                                                   last_name:      'Doe',
                                                                   street:         '125 Test Ave.',
                                                                   city:           'Warwick',
                                                                   state:          'Rhode Island',
                                                                   zip_code:       '12886',
                                                                   phone_number:   '4019460376',
                                                                   email_address:  'jane@example.com',
                                                                   gold_member:     false,
                                                                   balance:         25

  end
end

