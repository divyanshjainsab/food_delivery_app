class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.integer :category, null: false
      t.string :fssai_licence, null: false
      t.timestamps
    end
  end
end
