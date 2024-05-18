class DataImportService
  def self.import_data_from_api
    municipalities = Municipality.order(:id)
    ids = municipalities.pluck(:id)
    last_record = Weather.order(created_at: :desc).first
    @last_created_at = last_record.created_at if last_record

    if !@last_created_at || @last_created_at.to_date < Time.zone.today
      Weather.delete_all
      ids.each do |id|
        latitude = Municipality.find(id).latitude
        longitude = Municipality.find(id).longitude
        params = URI.encode_www_form({latitude: latitude, longitude: longitude})
        uri = URI.parse("https://api.open-meteo.com/v1/forecast?#{params}&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_probability_max&timezone=Asia%2FTokyo&past_days=7")
        response = Net::HTTP.get_response(uri)
        result = JSON.parse(response.body) 
        puts "ID: #{id}, Response: #{result.inspect}"
        name = Municipality.find(id).name

        if result["daily"].nil? || result["daily"]["time"].nil?
          Rails.logger.error "Data missing for Municipality ID: #{id}"
          next
        end

        for i in 0..13

          if result["daily"]["time"][i].nil?
            Rails.logger.error "Data missing for Municipality ID: #{id}, Index: #{i}"
            next
          end

          weather_code = HomeHelper.weather_code_return(result["daily"]["weather_code"][i])
          wear_symbol = HomeHelper.wear_symbol_return(result["daily"]["apparent_temperature_max"][i].to_i)
          record = Weather.new
          record.municipalities_id = id
          record.municipalities_name = name
          record.time = result["daily"]["time"][i]
          record.temperature_max = result["daily"]["temperature_2m_max"][i]
          record.temperature_min = result["daily"]["temperature_2m_min"][i]
          record.precipitation_probability = result["daily"]["precipitation_probability_max"][i]
          record.weather_code =  weather_code
          record.apparent_temperature_max = result["daily"]["apparent_temperature_max"][i]
          record.apparent_temperture_min = result["daily"]["apparent_temperature_min"][i]
          record.wear_symbol = wear_symbol
          ApplicationRecord.transaction do
            begin
              if record.save
                Rails.logger.info "Record saved for Municipality ID: #{id}, Date: #{record.time}"
              else
                Rails.logger.error "Failed to save record for Municipality ID: #{id}, Date: #{record.time}, Errors: #{record.errors.full_messages}"
              end
              # 他のデータ保存処理や操作
            rescue => e
              Rails.logger.error "Transaction failed: #{e.message}"
              raise ActiveRecord::Rollback
            end
          end

        end
      end
    else
    end
  end
end
