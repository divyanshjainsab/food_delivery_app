class CreateRiders < ActiveRecord::Migration[8.0]
  def change
    create_table :riders do |t|
      t.integer :status, null: false
      t.string :driving_licence, null: false
      t.string :vehical_number, null: false
      t.date :date_of_birth
      t.timestamps
    end
  end
end
