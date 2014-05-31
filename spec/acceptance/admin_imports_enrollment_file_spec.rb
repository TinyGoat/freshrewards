require 'acceptance/helper'

feature 'Administrator imports enrollment file', %q{
  As an administrator
  So that I can easily add new members to the Fresh Rewards program
  I want to be able import an enrollment file which has many users to be added to the program } do

  scenario 'Administrator successfully imports enrollment file ' do
    visit       'admin/enrollment/new'
    attach_file 'Enrollment CSV', Rails.root + 'spec/support/fixtures/enrollment.csv'
    click_on    'Upload enrollment'

    expect_flash_to_contain 'You enrollment file was processed successfully'
  end

  def expect_flash_to_contain(text)
    expect(page.find('#flash_notice')).to have_text text
  end
end

