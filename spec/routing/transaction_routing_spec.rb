require 'spec_helper'

describe 'Uploading a new transaction CSV file' do
  it 'routes GET "/admin/transaction/new" to admin/transaction#new' do
    expect( { get: '/admin/transaction/new'}).to route_to controller:   'admin/transactions',
                                                          action:       'new'
  end

  it 'routes POST "/admin/transaction" to admin/transaction#create' do
    expect( { post: '/admin/transaction'}).to route_to  controller:   'admin/transactions',
                                                        action:       'create'

  end
end

