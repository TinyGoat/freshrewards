Warden::Strategies.add(:customer_authentication) do
  def valid?
    params[:password] == Digest::MD5.new.update(ENV['FR_LOGIN_SECRET'].to_s + params[:user] + timestamp).hexdigest
  end

  def authenticate!
    begin
      customer = Customer.find(params[:user])

      success!(customer)
    rescue ActiveRecord::RecordNotFound
      fail!('A customer could not be found with the specificed ID')
    end
  end
end


