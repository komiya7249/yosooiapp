class DataImportService
  def self.import_data_from_api
    @municipalities = Municipality.where(category: 'topview').order(:id)
    ids = @municipalities.pluck(:id)
    last_record = Whether.order(created_at: :desc).first
    @last_created_at = last_record.created_at if last_record



    # ids.each do |id|
    #   latitude = Municipality.find(id).latitude
    #   longitude = Municipality.find(id).longitude
    #   params = URI.encode_www_form({latitude: latitude, longitude: longitude})
    #   uri = URI.parse("https://api.open-meteo.com/v1/forecast?#{params}&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=Asia%2FTokyo")
    #   response = Net::HTTP.get_response(uri)
    #   result = JSON.parse(response.body)
    #   @name = Municipality.find(id).name
    #   @existing_times = Whether.where(name: @name).pluck(:time)
    #   new_time_string = DateTime.parse(result["daily"]["time"][6])
    #   @new_time = new_time_string.strftime("%a, %d %b %Y")
      
    #   for i in 0..6
    #     record = Whether.new
    #     record.name = @name
    #     record.time = result["daily"]["time"][i]
    #     record.temperature_max = result["daily"]["temperature_2m_max"][i]
    #     record.temperature_min = result["daily"]["temperature_2m_min"][i]
    #     # record.precipitation_probability = result["precipitation_probability_max"][i]
    #     record.weather_code = result["daily"]["weather_code"][i]
    #     # record.save
    #   end

    # end
    return @last_created_at
  end
end
