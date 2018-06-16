class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.references :book, foreign_key: true, null: false, index: true
      t.text :question, null: false
      t.text :answer, null: false

      t.timestamps
    end
  end
end
