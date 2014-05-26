module ControllerHelpers
  def sign_in(account = double('account'))
    if account.nil?
      request.env['warden'].stub(:authenticate!).
        and_throw(:warden, {:scope => :user})
      controller.stub :current_account => nil
    else
      request.env['warden'].stub :authenticate! => account
      controller.stub :current_account => account
    end
  end
end
