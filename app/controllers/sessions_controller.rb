class SessionsController < ApplicationController

  def create
    sign_out(:customer)

    customer = warden.authenticate!({ id:      params[:user],
                                      recall: 'sessions#destroy',
                                      scope:  :customer})

    sign_in(:customer, customer)

    redirect_to profile_path(customer.id)
  end

  def destroy
    sign_out(:customer)

    redirect_to 'https://www.weismarkets.com'
  end
end
