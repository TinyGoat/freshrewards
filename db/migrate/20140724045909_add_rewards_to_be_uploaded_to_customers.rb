class AddRewardsToBeUploadedToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :rewards_to_be_uploaded, :integer
  end
end
