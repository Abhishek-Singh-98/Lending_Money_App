# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_11_30_131847) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loan_requests", force: :cascade do |t|
    t.float "desired_amount"
    t.float "desired_interest"
    t.integer "loan_tenure"
    t.integer "status"
    t.date "start_date"
    t.date "end_date"
    t.float "interest_payable"
    t.float "amount_payable"
    t.bigint "user_id", null: false
    t.string "special_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "user_confirmed"
    t.index ["user_id"], name: "index_loan_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "contact_number"
    t.text "address"
    t.integer "role"
    t.integer "proof_type"
    t.string "valid_proof_id"
    t.string "password_digest"
    t.boolean "fraud", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "max_limit"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "loan_requests", "users"
  add_foreign_key "wallets", "users"
end
