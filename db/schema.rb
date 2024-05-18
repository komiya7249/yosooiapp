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

ActiveRecord::Schema[7.1].define(version: 2024_05_16_150547) do
  create_table "municipalities", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
  end

  create_table "weathers", force: :cascade do |t|
    t.integer "municipalities_id"
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
