class AddSubToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :sub, :string
    add_index :pages, [:book_id, :sub]
  end
end
