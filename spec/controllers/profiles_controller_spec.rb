require 'spec_helper'

describe ProfilesController do

  describe '#show' do
    let!(:customer) { double }
    let!(:profile)  { Profile.new(customer) }

    before do
      controller.stub(:current_customer).and_return customer
      Profile.stub(:new).and_return profile
    end

    it 'creates a new profile for the current customer' do
      expect(Profile).to receive(:new).with customer

      get :show
    end

    it 'assigns the profile to the view' do
      get :show

      expect(assigns(:profile)).to eql profile
    end

    it 'renders the show template' do
      get :show

      expect(response).to render_template :show
    end
  end
end

