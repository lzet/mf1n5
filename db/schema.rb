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

ActiveRecord::Schema.define(version: 20170314134843) do

  create_table "descriptions", force: :cascade do |t|
    t.integer "item_id"
    t.integer "tag_id"
    t.index ["item_id"], name: "index_descriptions_on_item_id"
    t.index ["tag_id"], name: "index_descriptions_on_tag_id"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "value",      limit: 8
    t.integer  "wallet_id"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["user_id"], name: "index_items_on_user_id"
    t.index ["wallet_id"], name: "index_items_on_wallet_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.string  "color",   default: "#000000"
    t.integer "user_id"
    t.index ["name"], name: "index_tags_on_name"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "",         null: false
    t.string   "encrypted_password",               default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "timezone",                         default: "UTC"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "lang",                   limit: 4, default: "en"
    t.string   "outdateformat",                    default: "%Y.%m.%d"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.integer "user_id"
    t.string  "name"
    t.string  "currency", limit: 5
    t.integer "value",    limit: 8
    t.boolean "def",                default: false
    t.boolean "boolean",            default: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

end
