class CreateHourWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :hour_weathers do |t|
      t.date :time
      t.float :temperature
      t.float :apparent_temperature
      t.float :precipitation_probability
      t.string :weather_code
      t.string :wear_symbol
      t.integer :municipalities_id
      t.string :municipalities_name

      t.timestamps
    end
  end
end
