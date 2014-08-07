class Admin::BaseController < ::ApplicationController
   http_basic_authenticate_with name: "destination_rewards", password: ENV['ADMIN_PASSWORD']
end

