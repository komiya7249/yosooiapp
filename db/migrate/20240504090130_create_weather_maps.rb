class CreateWeatherMaps < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_maps do |t|
      t.integer :municipalities_id
      t.float :temperature_max
      t.float :temperature_min
      t.float :precipitation_probability
      t.integer :weather_code
      t.date :time

      t.timestamps
    end
  end
end
