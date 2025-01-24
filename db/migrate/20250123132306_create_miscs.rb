class CreateMiscs < ActiveRecord::Migration[8.0]
  def change
    create_table :miscs do |t|
      t.belongs_to :user
      t.integer :otp
      t.timestamps
    end
  end
end
