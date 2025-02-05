class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.belongs_to :client
      t.integer :amount, :null => false
      t.string :payment_method, :null => false
      t.string :payment_intent_id, :null => false
      t.string :status, :null => false
      t.datetime :paid_at
      t.datetime :failed_at
      t.timestamps
    end
  end
end
