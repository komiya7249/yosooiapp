class AddColumnToWeatherMaps < ActiveRecord::Migration[7.1]
  def change
    add_column :weather_maps, :apparent_temperature_max, :float
    add_column :weather_maps, :apparent_temperture_min, :float
  end
end
