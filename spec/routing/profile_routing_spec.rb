require 'spec_helper'

describe 'Viewing a customer profile' do
  it 'routes GET "/profile" to profiles#show' do
    expect( { get: '/profile'}).to route_to  controller:   'profiles',
                                             action:       'show'
  end
end
