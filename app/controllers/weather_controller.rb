class WeatherController < ApplicationController
  def show
    DataImportService.import_data_from_api
    @week = %w[(日) (月) (火) (水) (木) (金) (土)]
    @records = Weather.where("DATE(time) = ?", Time.zone.today).to_a
    @municipalities_name = Municipality.find(params[:id]).name
    @main_days = []
    @sub_days = []
    (0..6).each do |i|
      @main_days << (Time.zone.today+i).strftime("%m月%d日")
      @sub_days << (Time.zone.today-i-1).strftime("%m月%d日")
    end
    if params[:main_day] === nil
      @main_day =  (Time.zone.today).strftime("%m月%d日")
      @sub_day =  (Time.zone.today-1).strftime("%m月%d日")
      @city = @municipalities_name
      date_with_year_string = "#{Time.zone.today.year}年#{@main_day}"
      date = Date.strptime(date_with_year_string, "%Y年%m月%d日")
      sub_date_with_year_string = "#{Time.zone.today.year}年#{@sub_day}"
      sub_date = Date.strptime(sub_date_with_year_string, "%Y年%m月%d日")
      @main_wether_data = Weather.where(municipalities_name: @city, time: date).first
      @sub_wether_data = Weather.where(municipalities_name: @city, time: sub_date).first
    else
      @main_day = params[:main_day]
      @sub_day = params[:sub_day]
      @city =  @municipalities_name
      date_with_year_string = "#{Time.zone.today.year}年#{@main_day}"
      date = Date.strptime(date_with_year_string, "%Y年%m月%d日")
      sub_date_with_year_string = "#{Time.zone.today.year}年#{@sub_day}"
      sub_date = Date.strptime(sub_date_with_year_string, "%Y年%m月%d日")
      @main_wether_data = Weather.where(municipalities_name: @city, time: date).first
      @sub_wether_data = Weather.where(municipalities_name: @city, time: sub_date).first
    end
  end
end
