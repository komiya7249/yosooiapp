class AddColumnWearSymbolToWeatherMaps < ActiveRecord::Migration[7.1]
  def change
    add_column :weather_maps, :wear_symbol, :string
  end
end
