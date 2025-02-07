class AddRiderIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :rider_id, :integer
  end
end
