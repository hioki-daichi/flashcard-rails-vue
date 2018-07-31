class AddSubToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :sub, :string
    add_index :books, [:user_id, :sub]
  end
end
