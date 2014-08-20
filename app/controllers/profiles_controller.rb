class ProfilesController < ApplicationController

  def show
    if current_customer
      customer = Customer.find(params[:id])

      @profile = Profile.new(customer)

      render :show
    else
      redirect_to 'https://www.weismarkets.com'
    end
  end
end
