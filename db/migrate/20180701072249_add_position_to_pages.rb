class AddPositionToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :position, :integer
    add_index :pages, [:book_id, :position]
  end
end
