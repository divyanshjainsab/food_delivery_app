class CreateDishes < ActiveRecord::Migration[8.0]
  def change
    create_table :dishes do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2
      t.integer :category, null: false
      t.belongs_to :restaurant
      t.timestamps
    end
  end
end
