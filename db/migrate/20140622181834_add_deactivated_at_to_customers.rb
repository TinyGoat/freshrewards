class AddDeactivatedAtToCustomers < ActiveRecord::Migration
  def change
    add_column  :customers, :deactivated_at, :datetime
    add_index   :customers, :deactivated_at
  end
end
