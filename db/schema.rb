# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_04_013222) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "row_order"
    t.string "sub"
    t.index ["title"], name: "index_books_on_title"
    t.index ["user_id", "row_order"], name: "index_books_on_user_id_and_row_order"
    t.index ["user_id", "sub"], name: "index_books_on_user_id_and_sub"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.text "question", null: false
    t.text "answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "row_order"
    t.string "path", default: ""
    t.string "sub"
    t.index ["book_id", "row_order"], name: "index_pages_on_book_id_and_row_order"
    t.index ["book_id", "sub"], name: "index_pages_on_book_id_and_sub"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "pages", "books"
end
