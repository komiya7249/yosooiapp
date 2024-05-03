class HomeController < ApplicationController
  def index
   oume = URI.encode_www_form(latitude: 35.7879,longitude: 139.2758)
   uri = URI.parse("https://api.open-meteo.com/v1/forecast?latitude=35.7879,35.6978368,35.7379227,35.6899573&longitude=139.2758,139.4137252,139.6543421,139.7005071&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=Asia%2FTokyo")
   response = Net::HTTP.get_response(uri)
   result = JSON.parse(response.body)
   @temperature = result["daily"]["temperature_2m_max"][0]
  end
end
