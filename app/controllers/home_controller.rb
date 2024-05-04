class HomeController < ApplicationController
  def index
    DataImportService.import_data_from_api
    @weather_data = {}
    WeatherMap.include()

    id = 1
    @oume = Municipality.find(id).name
    @last_created_at = DataImportService.import_data_from_api
  end
end
