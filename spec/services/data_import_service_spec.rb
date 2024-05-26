require 'rails_helper'

RSpec.describe DataImportService, type: :service do
  describe 'weather_code_return' do
    it '0以上2以下の時にsunを返すこと' do
      expect(DataImportService.weather_code_return(1)).to eq("sun")
    end

    it '3の時にcloudを返すこと' do
      expect(DataImportService.weather_code_return(3)).to eq("cloud")
    end

    it '45以上57以下の時にfogを返すこと' do
      expect(DataImportService.weather_code_return(46)).to eq("fog")
    end

    it '61以上82以下の時にrainを返すこと' do
      expect(DataImportService.weather_code_return(70)).to eq("rain")
    end

    it '85以上86以下の時にsnowを返すこと' do
      expect(DataImportService.weather_code_return(85)).to eq("snow")
    end

    it '95以上99以下の時にthunderを返すこと' do
      expect(DataImportService.weather_code_return(98)).to eq("thunder")
    end
  end

  describe 'wear_symbol_return' do
    it '30以上の時にtshirtを返すこと' do
      expect(DataImportService.wear_symbol_return(35)).to eq("tshirt")
    end

    it '25以上29以下の時にshort_sleeve_shirtを返すこと' do
      expect(DataImportService.wear_symbol_return(27)).to eq("short_sleeve_shirt")
    end

    it '20以上24以下の時にlong_sleeve_shirtを返すこと' do
      expect(DataImportService.wear_symbol_return(23)).to eq("long_sleeve_shirt")
    end

    it '16以上19以下の時にJacketを返すこと' do
      expect(DataImportService.wear_symbol_return(18)).to eq("Jacket")
    end

    it '12以上15以下の時にnitを返すこと' do
      expect(DataImportService.wear_symbol_return(13)).to eq("nit")
    end

    it '6以上11以下の時にlight_outerwearを返すこと' do
      expect(DataImportService.wear_symbol_return(9)).to eq("light_outerwear")
    end

    it '6以上7以下の時にouterを返すこと' do
      expect(DataImportService.wear_symbol_return(7)).to eq("outer")
    end

    it '5以下の時にdown_coatを返すこと' do
      expect(DataImportService.wear_symbol_return(4)).to eq("down_coat")
    end

  end

  describe 'weather_generate_api_url' do
    it '指定された緯度経度に応じたURLを生成すること' do
      url = DataImportService.weather_generate_api_url(35.633635,139.711713)
      expected_url = URI.parse("https://api.open-meteo.com/v1/forecast?latitude=35.633635&longitude=139.711713&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_probability_max&timezone=Asia%2FTokyo&past_days=7")
      expect(url).to eq(expected_url)
    end
  end

  describe 'fetch_weather_data' do
    it '想定する情報をAPIで取得できること' do
      uri = URI.parse("https://api.open-meteo.com/v1/forecast?latitude=35.633635&longitude=139.711713&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_probability_max&timezone=Asia%2FTokyo&past_days=7")
      response_body = '{ "daily": { "time": ["2024-05-25"], "weather_code": [1], "temperature_2m_max": [25], "temperature_2m_min": [15], "apparent_temperature_max": [25], "apparent_temperature_min": [15], "precipitation_probability_max": [10] } }'
      allow(Net::HTTP).to receive(:get_response).and_return(double(body: response_body))
      result = DataImportService.fetch_weather_data(uri)
      expect(result).to eq(JSON.parse(response_body))
    end
  end

  describe 'save_weather_data' do
    let(:id) { 1 }
    let(:name) { 'dummy_municipality' }
    let(:result) {
      {   
        "daily" => {
          "time" => ["2024-05-25"],
          "weather_code" => [1],
          "temperature_2m_max" => [25],
          "temperature_2m_min" => [15],
          "apparent_temperature_max" => [25],
          "apparent_temperature_min" => [15],
          "precipitation_probability_max" => [10]
        }
      }
    }

    it '気象情報がデータベースへ保存されること' do
      expect { DataImportService.save_weather_data(id, name, result) }.to change { Weather.count }.by(1)
    end

    it '結果がnilの場合に保存されないこと' do
      expect { DataImportService.save_weather_data(id, name, {}) }.not_to change { Weather.count }
    end
  end

  describe 'import_weatherdata_from_api' do
    before do
      FactoryBot.create(:municipality)    
    end

    it '気象データを正しくインポートできること' do
      allow(DataImportService).to receive(:fetch_weather_data).and_return({
        "daily" => {
          "time" => ["2024-05-25"],
          "weather_code" => [1],
          "temperature_2m_max" => [25],
          "temperature_2m_min" => [15],
          "apparent_temperature_max" => [25],
          "apparent_temperature_min" => [15],
          "precipitation_probability_max" => [10]
        }
      })
      expect { DataImportService.import_weatherdata_from_api }.to change { Weather.count }.by(1)
    end
  end

  describe 'hourweather_generate_api_url' do
    it '指定された緯度経度に応じたURLを生成すること' do
      url = DataImportService.hourweather_generate_api_url(35.633635,139.711713)
      expected_url = URI.parse("https://api.open-meteo.com/v1/forecast?latitude=35.633635&longitude=139.711713&hourly=temperature_2m,apparent_temperature,precipitation_probability,weather_code&timezone=Asia%2FTokyo&forecast_days=1")
      expect(url).to eq(expected_url)
    end
  end

  describe 'save_hourweather_data' do
    let(:id) { 1 }
    let(:name) { 'dummy_municipality' }
    let(:result) {
      {   
        "hourly" => {
          "time" => ["2024-05-25"],
          "weather_code" => [1],
          "temperature_2m" => [15],
          "apparent_temperature" => [25],
          "precipitation_probability" => [10]
        }
      }
    }

    it '気象情報がデータベースへ保存されること' do
      expect { DataImportService.save_hourweather_data(id, name, result) }.to change { HourWeather.count }.by(1)
    end

    it '結果がnilの場合に保存されないこと' do
      expect { DataImportService.save_hourweather_data(id, name, {}) }.not_to change { HourWeather.count }
    end
  end

  describe 'import_hourweatherdata_from_api' do
    before do
      FactoryBot.create(:municipality, id:1)
    end

    it '気象データを正しくインポートできること' do

      allow(DataImportService).to receive(:fetch_weather_data).and_return({
        "hourly" => {
          "time" => ["2024-05-25"],
          "weather_code" => [1],
          "temperature_2m" => [15],
          "apparent_temperature" => [25],
          "precipitation_probability" => [10]
        }
      })
      expect { DataImportService.import_hourweatherdata_from_api(1) }.to change { HourWeather.count }.by(1)
    end
  end

end
