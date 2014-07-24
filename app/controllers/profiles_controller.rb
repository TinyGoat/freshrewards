class ProfilesController < ApplicationController

  def show
    customer = Customer.find(params[:id])

    @profile = Profile.new(customer)

    render :show
  end
end
