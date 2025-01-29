class CreateDishes < ActiveRecord::Migration[8.0]
  def change
    create_table :dishes do |t|
      t.integer :category, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, scale: 5, precision: 5
      t.belongs_to :restaurant
      t.timestamps
    end
  end
end
