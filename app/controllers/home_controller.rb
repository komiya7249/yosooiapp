class HomeController < ApplicationController
  include HomeHelper
  def index
    DataImportService.import_data_from_api
    @records = WeatherMap.where("DATE(time) = ?", Time.zone.today).to_a
    @municipalities = Municipality.where(category: 'topview').order(:id)
    ids = @municipalities.pluck(:id)
    @temperature_maxs = []
    @temperature_mins = []
    @weather_codes = []
    @wear_symbols = []
    @precipitation_probability_maxs = []
    (0..6).each do |i|
      hashs1 = []
      hashs2 = []
      hashs3 = []
      hashs4 = []
      hashs5 = []
      records = WeatherMap.where("DATE(time) = ?", Time.zone.today+i)
      ids.each do |id|
        record = records.find_by(municipalities_id: id)
        if record
          wear_symbol_value = record.apparent_temperature_max.to_i
          puts wear_symbol_value
          weather_code_value = HomeHelper.weather_code_return(record.weather_code)
          wear_symbol = HomeHelper.wear_symbol_return(wear_symbol_value)
          puts wear_symbol
          hash1 = { key: record.municipalities_name, value: record.temperature_max }
          hash2 = { key: record.municipalities_name, value: record.temperature_min }
          hash3 = { key: record.municipalities_name, value: weather_code_value }
          hash4 = { key: record.municipalities_name, value: record.precipitation_probability }
          hash5 = { key: record.municipalities_name, value: wear_symbol }
          hashs1 << hash1
          hashs2 << hash2
          hashs3 << hash3
          hashs4 << hash4
          hashs5 << hash5
        end
      end
      @temperature_maxs << hashs1
      @temperature_mins << hashs2
      @weather_codes << hashs3
      @precipitation_probability_maxs << hashs4
      @wear_symbols << hashs5
    end
  end
end
