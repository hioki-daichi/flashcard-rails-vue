class AddPositionToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :position, :integer
    add_index :books, [:user_id, :position]
  end
end
