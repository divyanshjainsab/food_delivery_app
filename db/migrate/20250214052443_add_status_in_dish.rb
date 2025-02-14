class AddStatusInDish < ActiveRecord::Migration[8.0]
  def change
    add_column :dishes, :status, :integer, default: 0
  end
end
