Warden::Strategies.add(:customer_authentication) do
  def valid?
    user_id   = params[:user]     || '0'
    timestamp = params[:ts]       || Time.now.to_i.to_s
    password  = params[:password] || '1234567'

    password == Digest::MD5.new.update(ENV['FR_LOGIN_SECRET'].to_s + user_id + timestamp).hexdigest
  end

  def authenticate!
    begin
      customer = Customer.find_by_weis_id(params[:user])

      success!(customer)
    rescue ActiveRecord::RecordNotFound
      fail!('A customer could not be found with the specificed ID')
    end
  end
end


