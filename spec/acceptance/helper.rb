require 'spec_helper'

RSpec.configure do |config|
  config.before do
    Net::SFTP.stub(:start)
  end
end

