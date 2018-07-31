class RemoveDuplicateIndexes < ActiveRecord::Migration[5.2]
  def change
    remove_index :pages, :book_id
    remove_index :books, :user_id
  end
end
