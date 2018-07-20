class RenamePositionToPages < ActiveRecord::Migration[5.2]
  def change
    rename_column :pages, :position, :row_order
  end
end
