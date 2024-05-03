class HomeController < ApplicationController
  def index
    municipalities = Municipality.where(category: 'topview').order(:id)
    latitudes = municipalities.pluck(:latitude)
    longitudes = municipalities.pluck(:longitude)
    params = URI.encode_www_form({latitude: latitudes,longitude: longitudes})
    uri = URI.parse("https://api.open-meteo.com/v1/forecast?#{params}&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=Asia%2FTokyo")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    @temperature = result
    @oume = Municipality.find_by(id: 1)
  end
end
