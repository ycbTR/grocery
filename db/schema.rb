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

ActiveRecord::Schema.define(version: 2019_04_02_200217) do

  create_table "account_activities", force: :cascade do |t|
    t.integer "order_id"
    t.decimal "amount"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_type"
    t.integer "source_id"
    t.integer "admin_id"
    t.index ["admin_id", "amount", "created_at"], name: "aa_i_2"
    t.index ["source_type", "created_at", "amount"], name: "aa_i_1"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "card"
    t.decimal "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.decimal "credit_limit"
    t.datetime "deleted_at"
    t.boolean "cashier"
    t.index ["deleted_at"], name: "acc_i_2"
    t.index ["name"], name: "acc_i_1"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "quantity"
    t.decimal "price"
    t.decimal "total"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.integer "canceled_by"
    t.index ["state", "order_id"], name: "li_i_1"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "account_id"
    t.decimal "total"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.integer "canceled_by"
    t.index ["state", "completed_at"], name: "o_i_1"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["deleted_at"], name: "pr_i_2"
    t.index ["name"], name: "pr_i_1"
  end

end
