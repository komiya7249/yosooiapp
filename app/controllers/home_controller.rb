class HomeController < ApplicationController
  include HomeHelper
  def index
    DataImportService.import_data_from_api
    @week = %w[(日) (月) (火) (水) (木) (金) (土)]
    @records = Weather.where("DATE(time) = ?", Time.zone.today).to_a
    @municipalities = Municipality.all
    @municipalities_name = Municipality.pluck(:name)
    @weathermap_municipalities = Municipality.where(category: 'topview').order(:id)
    ids = @weathermap_municipalities.pluck(:id)
    @temperature_maxs = []
    @temperature_mins = []
    @weather_codes = []
    @wear_symbols = []
    @precipitation_probability_maxs = []
    @main_days = []
    @sub_days = []

    (0..6).each do |i|
      hashs1 = []
      hashs2 = []
      hashs3 = []
      hashs4 = []
      hashs5 = []

      target_date  = Time.zone.today + i
      records = Weather.where("DATE(time) = ?AND municipalities_id IN (?)", target_date, ids)

      records_by_municipalities_id = records.group_by(&:municipalities_id)

      ids.each do |id|
        record = records_by_municipalities_id[id]&.first
        if record
          hash1 = { key: record.municipalities_name, value: record.temperature_max }
          hash2 = { key: record.municipalities_name, value: record.temperature_min }
          hash3 = { key: record.municipalities_name, value: record.weather_code }
          hash4 = { key: record.municipalities_name, value: record.precipitation_probability }
          hash5 = { key: record.municipalities_name, value: record.wear_symbol }
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
      @main_days << (Time.zone.today+i).strftime("%m月%d日")
      @sub_days << (Time.zone.today-i-1).strftime("%m月%d日")
    end

    if params[:main_day] === nil
      @main_day =  (Time.zone.today).strftime("%m月%d日")
      @sub_day =  (Time.zone.today-1).strftime("%m月%d日")
      @city = @municipalities_name[4]
      date_with_year_string = "#{Time.zone.today.year}年#{@main_day}"
      date = Date.strptime(date_with_year_string, "%Y年%m月%d日")
      sub_date_with_year_string = "#{Time.zone.today.year}年#{@sub_day}"
      sub_date = Date.strptime(sub_date_with_year_string, "%Y年%m月%d日")
      @main_wether_data = Weather.where(municipalities_name: @city, time: date).first
      @sub_wether_data = Weather.where(municipalities_name: @city, time: sub_date).first
    else
      @main_day = params[:main_day]
      @sub_day = params[:sub_day]
      @city = params[:municipalitie_name]
      date_with_year_string = "#{Time.zone.today.year}年#{@main_day}"
      date = Date.strptime(date_with_year_string, "%Y年%m月%d日")
      sub_date_with_year_string = "#{Time.zone.today.year}年#{@sub_day}"
      sub_date = Date.strptime(sub_date_with_year_string, "%Y年%m月%d日")
      @main_wether_data = Weather.where(municipalities_name: @city, time: date).first
      @sub_wether_data = Weather.where(municipalities_name: @city, time: sub_date).first
    end
  end
end
