class RenamePositionToBooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :position, :row_order
  end
end
