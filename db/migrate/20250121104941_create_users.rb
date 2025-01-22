class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.references :entryable, polymorphic: true, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :phone, null: false
      t.text :address, null: false
      t.timestamps
    end
  end
end
