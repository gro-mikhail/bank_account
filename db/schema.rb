# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_01_225853) do

  create_table "accounts", force: :cascade do |t|
    t.float "balance", default: 0.0, null: false
    t.string "account_number", null: false
    t.string "currency", null: false
    t.integer "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id", "currency"], name: "index_accounts_on_client_id_and_currency"
    t.index ["client_id"], name: "index_accounts_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "patronymic", null: false
    t.string "identification_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identification_number"], name: "index_clients_on_identification_number", unique: true
  end

  create_table "clients_tags", force: :cascade do |t|
    t.integer "client_id"
    t.integer "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.float "amount", null: false
    t.string "currency", null: false
    t.string "transaction_type", null: false
    t.boolean "transfer", default: false, null: false
    t.integer "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_transactions_on_client_id"
    t.index ["currency"], name: "index_transactions_on_currency"
    t.index ["transaction_type"], name: "index_transactions_on_transaction_type"
    t.index ["transfer"], name: "index_transactions_on_transfer"
  end

  add_foreign_key "accounts", "clients"
  add_foreign_key "transactions", "clients"
end
