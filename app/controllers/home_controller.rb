class HomeController < ApplicationController
  include HomeHelper
  def index
    DataImportService.import_data_from_api
    @week = %w[(日) (月) (火) (水) (木) (金) (土)]
    @weathermap_municipalities = Municipality.all
    start_date = Time.zone.today
    end_date = Time.zone.today + 6.days
    weathermap_weathers = Weather.where(time: start_date..end_date)
    @okutama_weathers = weathermap_weathers.where(municipalities_name: "奥多摩町")
    @oume_weathers = weathermap_weathers.where(municipalities_name: "青梅市")
    @tachikawa_weathers = weathermap_weathers.where(municipalities_name: "立川市")
    @nerima_weathers = weathermap_weathers.where(municipalities_name: "練馬区")
    @shinjuku_weathers = weathermap_weathers.where(municipalities_name: "新宿区")
    @chiyoda_weathers = weathermap_weathers.where(municipalities_name: "千代田区")
    @shinagawa_weathers = weathermap_weathers.where(municipalities_name: "品川区")
    @setagaya_weathers = weathermap_weathers.where(municipalities_name: "世田谷区")
    @hachioji_weathers = weathermap_weathers.where(municipalities_name: "八王子市")
    @hinohara_weathers = weathermap_weathers.where(municipalities_name: "檜原村")

    @main_days = []
    @sub_days = []

    (0..6).each do |i|
      @main_days << (Time.zone.today+i).strftime("%m月%d日")
      @sub_days << (Time.zone.today-i-1).strftime("%m月%d日")
    end

    if params[:main_day] === nil
      @main_day =  (Time.zone.today).strftime("%m月%d日")
      @sub_day =  (Time.zone.today-1).strftime("%m月%d日")
      @city = Municipality.pluck(:name)[4]
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
