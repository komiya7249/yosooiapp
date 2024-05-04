class ChangePrecipitationProbabilityTypeInWeatherMaps < ActiveRecord::Migration[7.1]
  def change
    change_column :weather_maps, :precipitation_probability, :integer
  end
end
