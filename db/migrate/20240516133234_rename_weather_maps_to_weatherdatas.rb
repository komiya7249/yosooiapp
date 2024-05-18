class RenameWeatherMapsToWeatherdatas < ActiveRecord::Migration[7.1]
  def change
    rename_table :weather_maps, :weatherdatas
  end
end
