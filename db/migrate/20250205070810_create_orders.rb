class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.belongs_to :client
      t.belongs_to :dish
      t.belongs_to :payment
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
