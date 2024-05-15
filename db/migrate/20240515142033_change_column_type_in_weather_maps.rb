class ChangeColumnTypeInWeatherMaps < ActiveRecord::Migration[7.1]
  def change
    change_column :weather_maps, :weather_code, :string
  end
end
