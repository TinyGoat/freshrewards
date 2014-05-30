require 'spec_helper'

describe 'Uploading a new enrollment CSV file' do
  it 'routes GET "/admin/enrollment/new" to admin/enrollments#new' do
    expect( { get: '/admin/enrollment/new'}).to route_to  controller:   'admin/enrollments',
                                                          action:       'new'
  end

  it 'routes POST "/admin/enrollment" to admin/enrollments#create' do
    expect( { post: '/admin/enrollment'}).to route_to controller:   'admin/enrollments',
                                                      action:       'create'

  end
end
