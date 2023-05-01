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

ActiveRecord::Schema[7.0].define(version: 2023_04_28_022844) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "addition_type", ["deduction", "salary_income", "non_salary_income"]
  create_enum "contract_terms", ["fixed", "indefinite"]
  create_enum "risk_type", ["risk_1", "risk_2", "risk_3", "risk_4", "risk_5"]

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "nit", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "contracts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "job_title", null: false
    t.enum "term", null: false, enum_type: "contract_terms"
    t.string "health_provider", null: false
    t.enum "risk_type", null: false, enum_type: "risk_type"
    t.date "initial_date", null: false
    t.date "end_date"
    t.uuid "worker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["worker_id"], name: "index_contracts_on_worker_id"
  end

  create_table "payroll_additions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "payroll_id", null: false
    t.string "name"
    t.enum "addition_type", null: false, enum_type: "addition_type"
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payroll_id"], name: "index_payroll_additions_on_payroll_id"
  end

  create_table "payrolls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "period_id", null: false
    t.uuid "worker_id", null: false
    t.decimal "base_salary", precision: 15, scale: 2, null: false
    t.decimal "transport_subsidy", precision: 15, scale: 2, null: false
    t.decimal "additional_salary_income", precision: 15, scale: 2, null: false
    t.decimal "non_salary_income", precision: 15, scale: 2, null: false
    t.decimal "worker_healthcare", precision: 15, scale: 2, null: false
    t.decimal "worker_pension", precision: 15, scale: 2, null: false
    t.decimal "solidarity_fund", precision: 15, scale: 2, null: false
    t.decimal "subsistence_account", precision: 15, scale: 2, null: false
    t.decimal "deductions", precision: 15, scale: 2, null: false
    t.decimal "company_healthcare", precision: 15, scale: 2, null: false
    t.decimal "company_pension", precision: 15, scale: 2, null: false
    t.decimal "arl", precision: 15, scale: 2, null: false
    t.decimal "compensation_fund", precision: 15, scale: 2, null: false
    t.decimal "icbf", precision: 15, scale: 2, null: false
    t.decimal "sena", precision: 15, scale: 2, null: false
    t.decimal "severance", precision: 15, scale: 2, null: false
    t.decimal "interest", precision: 15, scale: 2, null: false
    t.decimal "premium", precision: 15, scale: 2, null: false
    t.decimal "vacation", precision: 15, scale: 2, null: false
    t.decimal "worker_payment", precision: 15, scale: 2, null: false
    t.decimal "total_company_cost", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period_id"], name: "index_payrolls_on_period_id"
    t.index ["worker_id"], name: "index_payrolls_on_worker_id"
  end

  create_table "periods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_periods_on_company_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "base_salary", precision: 15, scale: 2, null: false
    t.boolean "transport_subsidy", null: false
    t.date "initial_date", null: false
    t.date "end_date"
    t.uuid "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_wages_on_contract_id"
  end

  create_table "workers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "id_number", null: false
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_workers_on_company_id"
  end

  add_foreign_key "companies", "users"
  add_foreign_key "contracts", "workers"
  add_foreign_key "payroll_additions", "payrolls"
  add_foreign_key "payrolls", "periods"
  add_foreign_key "payrolls", "workers"
  add_foreign_key "periods", "companies"
  add_foreign_key "wages", "contracts"
  add_foreign_key "workers", "companies"
end
