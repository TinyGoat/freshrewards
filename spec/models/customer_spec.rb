require 'spec_helper'

describe Customer do

  it 'is valid with valid attributes' do
    expect(Customer.new).to be_valid
  end
end

