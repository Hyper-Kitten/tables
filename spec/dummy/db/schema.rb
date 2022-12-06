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

ActiveRecord::Schema[7.0].define(version: 2022_09_30_141953) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categorical_taggings", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id"
    t.index ["tag_id"], name: "index_categorical_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_categorical_taggings_on_taggable"
  end

  create_table "categorical_tags", force: :cascade do |t|
    t.string "label"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_categorical_tags_on_label", unique: true
    t.index ["slug"], name: "index_categorical_tags_on_slug", unique: true
  end

  create_table "hyper_kitten_meow_menu_items", force: :cascade do |t|
    t.bigint "page_id"
    t.bigint "menu_id", null: false
    t.string "title"
    t.string "url"
    t.boolean "new_window", default: false, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_hyper_kitten_meow_menu_items_on_menu_id"
    t.index ["page_id"], name: "index_hyper_kitten_meow_menu_items_on_page_id"
  end

  create_table "hyper_kitten_meow_menus", force: :cascade do |t|
    t.string "name"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_hyper_kitten_meow_menus_on_slug"
  end

  create_table "hyper_kitten_meow_pages", force: :cascade do |t|
    t.string "title"
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.text "body"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_hyper_kitten_meow_pages_on_slug", unique: true
  end

  create_table "hyper_kitten_meow_posts", force: :cascade do |t|
    t.string "title"
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.text "summary"
    t.text "body"
    t.string "slug"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_hyper_kitten_meow_posts_on_slug", unique: true
    t.index ["user_id"], name: "index_hyper_kitten_meow_posts_on_user_id"
  end

  create_table "hyper_kitten_meow_users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_hyper_kitten_meow_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categorical_taggings", "categorical_tags", column: "tag_id"
  add_foreign_key "hyper_kitten_meow_menu_items", "hyper_kitten_meow_menus", column: "menu_id"
  add_foreign_key "hyper_kitten_meow_menu_items", "hyper_kitten_meow_pages", column: "page_id"
  add_foreign_key "hyper_kitten_meow_posts", "hyper_kitten_meow_users", column: "user_id"
end
