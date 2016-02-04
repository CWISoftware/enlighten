# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160203155500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "activity_owner_id"
    t.string   "activity_owner_type"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
  end

  add_index "activities", ["activity_owner_type", "activity_owner_id"], name: "index_activities_on_activity_owner_type_and_activity_owner_id", using: :btree
  add_index "activities", ["item_type", "item_id"], name: "index_activities_on_item_type_and_item_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "card_attachments", force: :cascade do |t|
    t.integer  "card_id"
    t.string   "attachment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "card_attachments", ["card_id"], name: "index_card_attachments_on_card_id", using: :btree

  create_table "card_galleries", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "timeout"
    t.integer  "order"
    t.string   "attachment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "card_galleries", ["card_id"], name: "index_card_galleries_on_card_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "section"
    t.string   "title"
    t.string   "subtitle"
    t.text     "description"
    t.text     "style"
    t.integer  "size"
    t.integer  "cardable_id"
    t.string   "cardable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "cards", ["cardable_type", "cardable_id"], name: "index_cards_on_cardable_type_and_cardable_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_id"
  end

  create_table "people", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_id"
  end

  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

  create_table "permission_acls", force: :cascade do |t|
    t.string   "model"
    t.string   "action"
    t.integer  "permission_role_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "permission_acls", ["permission_role_id"], name: "index_permission_acls_on_permission_role_id", using: :btree

  create_table "permission_roles", force: :cascade do |t|
    t.string   "name"
    t.boolean  "default",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "person_technologies", force: :cascade do |t|
    t.integer "person_id"
    t.integer "technology_id"
    t.integer "skill_rating",  default: 0, null: false
    t.boolean "certificated"
  end

  add_index "person_technologies", ["person_id"], name: "index_person_technologies_on_person_id", using: :btree
  add_index "person_technologies", ["technology_id"], name: "index_person_technologies_on_technology_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_members", force: :cascade do |t|
    t.integer "project_id"
    t.integer "person_id"
    t.date    "period_start"
    t.date    "period_end"
    t.integer "role_id"
  end

  add_index "project_members", ["person_id"], name: "index_project_members_on_person_id", using: :btree
  add_index "project_members", ["project_id"], name: "index_project_members_on_project_id", using: :btree
  add_index "project_members", ["role_id"], name: "index_project_members_on_role_id", using: :btree

  create_table "project_screenshots", force: :cascade do |t|
    t.integer  "project_id"
    t.text     "description"
    t.string   "image_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "project_screenshots", ["project_id"], name: "index_project_screenshots_on_project_id", using: :btree

  create_table "project_technologies", force: :cascade do |t|
    t.integer "project_id"
    t.integer "technology_id"
  end

  add_index "project_technologies", ["project_id"], name: "index_project_technologies_on_project_id", using: :btree
  add_index "project_technologies", ["technology_id"], name: "index_project_technologies_on_technology_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "scm_type"
    t.string   "scm_reference"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "image_id"
    t.integer  "client_id"
  end

  add_index "projects", ["client_id"], name: "index_projects_on_client_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "social_links", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "provider"
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "social_links", ["person_id"], name: "index_social_links_on_person_id", using: :btree

  create_table "technologies", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "image_id"
    t.integer  "technology_category_id"
    t.integer  "parent_id"
  end

  add_index "technologies", ["parent_id"], name: "index_technologies_on_parent_id", using: :btree
  add_index "technologies", ["technology_category_id"], name: "index_technologies_on_technology_category_id", using: :btree

  create_table "technology_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_following_cards", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_following_cards", ["card_id"], name: "index_users_following_cards_on_card_id", using: :btree
  add_index "users_following_cards", ["user_id", "card_id"], name: "index_users_following_cards_on_user_id_and_card_id", unique: true, using: :btree
  add_index "users_following_cards", ["user_id"], name: "index_users_following_cards_on_user_id", using: :btree

  create_table "users_following_clients", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_following_clients", ["client_id"], name: "index_users_following_clients_on_client_id", using: :btree
  add_index "users_following_clients", ["user_id", "client_id"], name: "index_users_following_clients_on_user_id_and_client_id", unique: true, using: :btree
  add_index "users_following_clients", ["user_id"], name: "index_users_following_clients_on_user_id", using: :btree

  create_table "users_following_people", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_following_people", ["person_id"], name: "index_users_following_people_on_person_id", using: :btree
  add_index "users_following_people", ["user_id", "person_id"], name: "index_users_following_people_on_user_id_and_person_id", unique: true, using: :btree
  add_index "users_following_people", ["user_id"], name: "index_users_following_people_on_user_id", using: :btree

  create_table "users_following_projects", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_following_projects", ["project_id"], name: "index_users_following_projects_on_project_id", using: :btree
  add_index "users_following_projects", ["user_id", "project_id"], name: "index_users_following_projects_on_user_id_and_project_id", unique: true, using: :btree
  add_index "users_following_projects", ["user_id"], name: "index_users_following_projects_on_user_id", using: :btree

  create_table "users_following_technologies", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_following_technologies", ["technology_id"], name: "index_users_following_technologies_on_technology_id", using: :btree
  add_index "users_following_technologies", ["user_id", "technology_id"], name: "index_users_following_technologies_on_user_id_and_technology_id", unique: true, using: :btree
  add_index "users_following_technologies", ["user_id"], name: "index_users_following_technologies_on_user_id", using: :btree

  create_table "users_liking_cards", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_liking_cards", ["card_id"], name: "index_users_liking_cards_on_card_id", using: :btree
  add_index "users_liking_cards", ["user_id", "card_id"], name: "index_users_liking_cards_on_user_id_and_card_id", unique: true, using: :btree
  add_index "users_liking_cards", ["user_id"], name: "index_users_liking_cards_on_user_id", using: :btree

  create_table "users_liking_clients", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_liking_clients", ["client_id"], name: "index_users_liking_clients_on_client_id", using: :btree
  add_index "users_liking_clients", ["user_id", "client_id"], name: "index_users_liking_clients_on_user_id_and_client_id", unique: true, using: :btree
  add_index "users_liking_clients", ["user_id"], name: "index_users_liking_clients_on_user_id", using: :btree

  create_table "users_liking_people", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_liking_people", ["person_id"], name: "index_users_liking_people_on_person_id", using: :btree
  add_index "users_liking_people", ["user_id", "person_id"], name: "index_users_liking_people_on_user_id_and_person_id", unique: true, using: :btree
  add_index "users_liking_people", ["user_id"], name: "index_users_liking_people_on_user_id", using: :btree

  create_table "users_liking_projects", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_liking_projects", ["project_id"], name: "index_users_liking_projects_on_project_id", using: :btree
  add_index "users_liking_projects", ["user_id", "project_id"], name: "index_users_liking_projects_on_user_id_and_project_id", unique: true, using: :btree
  add_index "users_liking_projects", ["user_id"], name: "index_users_liking_projects_on_user_id", using: :btree

  create_table "users_liking_technologies", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_liking_technologies", ["technology_id"], name: "index_users_liking_technologies_on_technology_id", using: :btree
  add_index "users_liking_technologies", ["user_id", "technology_id"], name: "index_users_liking_technologies_on_user_id_and_technology_id", unique: true, using: :btree
  add_index "users_liking_technologies", ["user_id"], name: "index_users_liking_technologies_on_user_id", using: :btree

  create_table "users_permission_roles", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "permission_role_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "users_permission_roles", ["permission_role_id"], name: "index_users_permission_roles_on_permission_role_id", using: :btree
  add_index "users_permission_roles", ["user_id", "permission_role_id"], name: "index_users_permission_roles_on_user_id_and_permission_role_id", unique: true, using: :btree
  add_index "users_permission_roles", ["user_id"], name: "index_users_permission_roles_on_user_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "activities", "users"
  add_foreign_key "card_attachments", "cards"
  add_foreign_key "card_galleries", "cards"
  add_foreign_key "people", "users"
  add_foreign_key "permission_acls", "permission_roles"
  add_foreign_key "project_members", "roles"
  add_foreign_key "project_screenshots", "projects"
  add_foreign_key "projects", "clients"
  add_foreign_key "social_links", "people"
  add_foreign_key "technologies", "technology_categories"
  add_foreign_key "users_following_cards", "cards"
  add_foreign_key "users_following_cards", "users"
  add_foreign_key "users_following_clients", "clients"
  add_foreign_key "users_following_clients", "users"
  add_foreign_key "users_following_people", "people"
  add_foreign_key "users_following_people", "users"
  add_foreign_key "users_following_projects", "projects"
  add_foreign_key "users_following_projects", "users"
  add_foreign_key "users_following_technologies", "technologies"
  add_foreign_key "users_following_technologies", "users"
  add_foreign_key "users_liking_cards", "cards"
  add_foreign_key "users_liking_cards", "users"
  add_foreign_key "users_liking_clients", "clients"
  add_foreign_key "users_liking_clients", "users"
  add_foreign_key "users_liking_people", "people"
  add_foreign_key "users_liking_people", "users"
  add_foreign_key "users_liking_projects", "projects"
  add_foreign_key "users_liking_projects", "users"
  add_foreign_key "users_liking_technologies", "technologies"
  add_foreign_key "users_liking_technologies", "users"
  add_foreign_key "users_permission_roles", "permission_roles"
  add_foreign_key "users_permission_roles", "users"
end
