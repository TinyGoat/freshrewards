class SessionsController < ApplicationController

  def create
    sign_out(:customer)

    customer = warden.authenticate!({ id:      params[:user],
                                      recall: 'home#faqs',
                                      scope:  :customer})

    sign_in(:customer, customer)

    redirect_to profile_path(customer.id)
  end
end
