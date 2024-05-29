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

ActiveRecord::Schema[7.1].define(version: 2024_05_28_122302) do
  create_table "hour_weathers", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "time"
    t.float "temperature"
    t.float "apparent_temperature"
    t.float "precipitation_probability"
    t.string "weather_code"
    t.string "wear_symbol"
    t.integer "municipality_id"
    t.string "municipalities_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "municipalities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "area"
  end

  create_table "weathers", charset: "utf8mb3", force: :cascade do |t|
    t.integer "municipality_id"
    t.float "temperature_max"
    t.float "temperature_min"
    t.float "precipitation_probability"
    t.string "weather_code"
    t.string "wear_symbol"
    t.float "apparent_temperature_max"
    t.float "apparent_temperture_min"
    t.date "time"
    t.string "municipalities_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
