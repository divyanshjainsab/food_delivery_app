class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :restaurant
      t.string :title, null: false
      t.text :description, null: false
      t.float :rating, null: false
      t.timestamps
    end
  end
end
