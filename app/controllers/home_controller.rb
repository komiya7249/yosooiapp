class HomeController < ApplicationController
  def index
    @temperature = DataImportService.import_data_from_api
    id = 1
    @oume = Municipality.find(id).name
    @last_created_at = DataImportService.import_data_from_api
  end
end
