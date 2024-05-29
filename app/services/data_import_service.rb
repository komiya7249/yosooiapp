class DataImportService

  def self.weather_code_return(code)
    if code >=0 && code <= 2
      return "sun"
    elsif code === 3
      return "cloud"
    elsif code >= 45 && code <= 57
      return "fog"
    elsif code >= 61 && code <= 82
      return "rain"
    elsif code >= 85 && code <= 86
      return "snow"
    elsif code >= 95 && code <= 99
      return "thunder"
    end
  end

  def self.wear_symbol_return(num)
    if num >= 30
      return "tshirt"
    elsif num >= 25 && num <= 29
      return "short_sleeve_shirt"
    elsif num >= 20 && num <= 24
      return "long_sleeve_shirt"
    elsif num >= 16 && num <= 19
      return "Jacket"
    elsif num >= 12 && num <= 15
      return "nit"
    elsif num >= 8 && num <= 11
      return "light_outerwear"
    elsif num >= 6 && num <= 7
      return "outer"
    elsif num <= 5
      return "down_coat"
    end
  end

  def self.weather_generate_api_url(latitude, longitude)
    params = URI.encode_www_form({latitude: latitude, longitude: longitude})
    URI.parse("https://api.open-meteo.com/v1/forecast?#{params}&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_probability_max&timezone=Asia%2FTokyo&past_days=7")
  end

  def self.fetch_weather_data(uri)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body) 
  end

  def self.save_weather_data(id, name, result)
    return if result["daily"].nil? || result["daily"]["time"].nil?

    (0..13).each do |i|
      next if result["daily"]["time"][i].nil?

      weather_code = weather_code_return(result["daily"]["weather_code"][i])
      wear_symbol = wear_symbol_return(result["daily"]["apparent_temperature_max"][i].to_i)
      record = Weather.new(
      municipality_id: id,
      municipalities_name: name,
      time: result["daily"]["time"][i],
      temperature_max: result["daily"]["temperature_2m_max"][i],
      temperature_min: result["daily"]["temperature_2m_min"][i],
      precipitation_probability: result["daily"]["precipitation_probability_max"][i],
      weather_code:  weather_code,
      apparent_temperature_max: result["daily"]["apparent_temperature_max"][i],
      apparent_temperture_min: result["daily"]["apparent_temperature_min"][i],
      wear_symbol: wear_symbol
      )

      ApplicationRecord.transaction do
        begin
          if record.save
            Rails.logger.info "Record saved for Municipality ID: #{id}, Date: #{record.time}"
          else
            Rails.logger.error "Failed to save record for Municipality ID: #{id}, Date: #{record.time}, Errors: #{record.errors.full_messages}"
          end
        rescue => e
          Rails.logger.error "Transaction failed: #{e.message}"
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  def self.import_weatherdata_from_api
    municipalities = Municipality.order(:id)
    ids = municipalities.pluck(:id)
    last_record = Weather.order(created_at: :desc).first
    last_created_at = last_record&.created_at

    if !last_created_at || last_created_at.to_date < Time.zone.today
      Weather.delete_all
      ids.each do |id|
        municipality = Municipality.find(id)
        uri = weather_generate_api_url(municipality.latitude, municipality.longitude)
        result = fetch_weather_data(uri)
        puts "ID: #{id}, Response: #{result.inspect}"
        save_weather_data(id, municipality.name, result)
      end
    end
  end



  def self.hourweather_generate_api_url(latitude, longitude)
    params = URI.encode_www_form({latitude: latitude, longitude: longitude})
    URI.parse("https://api.open-meteo.com/v1/forecast?#{params}&hourly=temperature_2m,apparent_temperature,precipitation_probability,weather_code&timezone=Asia%2FTokyo&forecast_days=1")
  end


  def self.save_hourweather_data(id, name, result)
    return if result["hourly"].nil? || result["hourly"]["time"].nil?

    (0..23).each do |i|
      next if result["hourly"]["time"][i].nil?

      weather_code = weather_code_return(result["hourly"]["weather_code"][i])
      wear_symbol = wear_symbol_return(result["hourly"]["apparent_temperature"][i].to_i)
      record = HourWeather.new(
      time: result["hourly"]["time"][i],
      temperature: result["hourly"]["temperature_2m"][i],
      apparent_temperature: result["hourly"]["apparent_temperature"][i],
      precipitation_probability: result["hourly"]["precipitation_probability"][i],
      wear_symbol: wear_symbol,
      weather_code: weather_code,
      municipality_id: id,
      municipalities_name: name
      )

      ApplicationRecord.transaction do
        begin
          if record.save
            Rails.logger.info "Record saved for Municipality ID: #{id}, Date: #{record.time}"
          else
            Rails.logger.error "Failed to save record for Municipality ID: #{id}, Date: #{record.time}, Errors: #{record.errors.full_messages}"
          end
        rescue => e
          Rails.logger.error "Transaction failed: #{e.message}"
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  def self.import_hourweatherdata_from_api(id)
    municipality = Municipality.where(id: id).first
    last_record = HourWeather.where(municipality_id: id).order(created_at: :desc).first
    last_created_at = last_record&.created_at

    if !last_created_at || last_created_at.to_date < Time.zone.today
      HourWeather.delete_all
      uri = hourweather_generate_api_url(municipality.latitude, municipality.longitude)
      result = fetch_weather_data(uri)
      puts "ID: #{id}, Response: #{result.inspect}"
      save_hourweather_data(id, municipality.name, result)
    end
  end
end

