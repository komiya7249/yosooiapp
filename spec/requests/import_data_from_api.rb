require 'rails_helper'

RSpec.describe DataImportService, type: :request do
  describe 'DataImportService#import_data_from_api' do
    it 'Municipalityのモックを作成し、テストデータを定義' do
      municipality = instance_double('Municipality', id: 1, name: 'Test Municipality', latitude: 35.6895, longitude: 139.6917)
      allow(Municipality).to receive(:find).with(1).and_return(municipality)

      mock_response = {
        "daily" => {
          "weather_code" => [3, 0],
          "temperature_2m_max" => [25.4, 28.3],
          "temperature_2m_min" => [20.1, 22.4],
          "apparent_temperature_max" => [26.2, 29.3],
          "apparent_temperature_min" => [21.4, 23.3],
          "precipitation_probability_max" => [80, 12]
        }
      }
      allow(Net::HTTP).to receive(:get_response).and_return(double(body: mock_response.to_json))

      DataImportService.import_data_from_api

      expect(Weather.count).to eq(2)

    end

  end
end
