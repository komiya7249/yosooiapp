class WeatherController < ApplicationController
  def show
    DataImportService.import_weatherdata_from_api
    id = params[:id]
    DataImportService.import_hourweatherdata_from_api(id)

    @week = %w[(日) (月) (火) (水) (木) (金) (土)]
    @records = Weather.where("DATE(time) = ?", Time.zone.today).to_a
    @municipalities_name = Municipality.find(params[:id]).name
    start_date = Time.zone.today
    end_date = Time.zone.today + 6.days
    @weekly_weathers = Weather.where(municipalities_id: params[:id]).where(time: start_date..end_date)
    @weekly_days = []
    @week_array = []
    @main_days = []
    @sub_days = []

    @hour_weathers = HourWeather.all

    (0..6).each do |i|
      records = Weather.where(municipalities_id: params[:id]).where(time:Time.zone.today+ i.day).first
      @weekly_days << (Time.zone.today + i.day).strftime("%d日")
      @week_array << @week[(Date.today+ i.day).wday]
      main_date =  (Time.zone.today+i)
      sub_date = (Time.zone.today-i-1)
      main_week = @week[main_date.wday]
      sub_week = @week[sub_date.wday]
      @main_days << "#{main_date.strftime("%m月%d日")} #{main_week} "
      @sub_days << "#{sub_date.strftime("%m月%d日")} #{sub_week} "
    end

    if params[:main_day] === nil
      @main_day = @main_days[0]
      @sub_day =  @sub_days[0]
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
