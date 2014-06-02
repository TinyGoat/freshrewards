class AddRewardsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :rewards, :date, array: true, default: '{}'
  end
end
