class ProfilesController < ApplicationController

  def show

    @profile = Profile.new(current_customer)

    render :show
  end
end
