class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.column      :weis_id, :bigint
      t.string      :first_name
      t.string      :middle_name
      t.string      :last_name

      t.string      :email_address
      t.string      :password

      t.string      :street
      t.string      :city
      t.string      :state
      t.string      :zip_code
      t.string      :phone_number

      t.integer     :balance
      t.boolean     :gold_member

      t.references  :program
      t.references  :buyer
    end
  end
end
