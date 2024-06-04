class ChangeMunicipalitiesIdInWeather < ActiveRecord::Migration[7.1]
  def change
    rename_column :weathers, :municipalities_id, :municipality_id
    rename_column :hour_weathers, :municipalities_id, :municipality_id
  end
end
