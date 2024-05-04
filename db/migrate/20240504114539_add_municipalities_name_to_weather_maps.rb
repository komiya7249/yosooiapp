class AddMunicipalitiesNameToWeatherMaps < ActiveRecord::Migration[7.1]
  def change
    add_column :weather_maps, :municipalities_name, :string
  end
end
