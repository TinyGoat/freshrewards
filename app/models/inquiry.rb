class Inquiry
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  attr_accessor :name, :email, :message, :nickname
  
  validates :name, 
            :presence => true
  
  validates :email,
            :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  
  validates :message,
            :length => { :minimum => 10, :maximum => 1000 }

  validates :nickname, 
            :format => { :with => /^$/, :multiline => true }
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def deliver
    return false unless valid?
    Pony.mail({
      :to => %("nickmjones@gmail.com"),
      :from => %("#{name}" <#{email}>),
      :reply_to => email,
      :subject => "Customer Service Request, Fresh Rewards",
      :body => message
    })
  end
      
  def persisted?
    false
  end

  private
  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :message, :nickname)
  end
end