# spec/services/weather_data_service_spec.rb
require 'rails_helper'

RSpec.describe WeatherDataService, type: :service do
  let(:zip_code) { '10001' }
  let(:service) { WeatherDataService.new }
  
  # Mock data for current weather
  let(:mock_current_response) do
    {
      "current" => { "temp_f" => 70.0, "temp_c" => 21.1 }
    }
  end
  
  # Mock data for forecast weather
  let(:mock_forecast_response) do
    {
      "forecast" => {
        "forecastday" => [
          {
            "day" => { 
              "maxtemp_f" => 80.0, 
              "maxtemp_c" => 26.7, 
              "mintemp_f" => 60.0, 
              "mintemp_c" => 15.6 
            }
          }
        ]
      }
    }
  end

  before do
    # Clear cache before each test to ensure a fresh start
    Rails.cache.clear

    # Stub API responses to return the mock data for current and forecast endpoints
    allow(service).to receive(:get_weather_data).with('/current.json', hash_including(q: zip_code)).and_return(mock_current_response)
    allow(service).to receive(:get_weather_data).with('/forecast.json', hash_including(q: zip_code, days: 1)).and_return(mock_forecast_response)
  end

  describe '#fetch_weather_data' do
    it 'fetches and returns the current and forecast weather data' do
      result = service.fetch_weather_data(zip_code)

      # Verify current weather data
      expect(result[:data][:current]["temp_f"]).to eq(70.0)
      expect(result[:data][:current]["temp_c"]).to eq(21.1)

      # Verify forecast weather data
      expect(result[:data][:forecast]["maxtemp_f"]).to eq(80.0)
      expect(result[:data][:forecast]["maxtemp_c"]).to eq(26.7)
      expect(result[:data][:forecast]["mintemp_f"]).to eq(60.0)
      expect(result[:data][:forecast]["mintemp_c"]).to eq(15.6)

      # Verify that the data is not cached since it’s a fresh request
      expect(result[:cached]).to be_falsey
    end

    it 'caches the response after fetching it' do
      # Ensure Rails.cache.write is called with the correct data format
      expect(Rails.cache).to receive(:write).with("weather_data_#{zip_code}", anything, expires_in: 30.minutes)
      service.fetch_weather_data(zip_code)
    end

    it 'returns cached data if available' do
      # Manually store data in cache to simulate cached data availability
      cached_data = {
        current: mock_current_response["current"],
        forecast: mock_forecast_response.dig("forecast", "forecastday", 0, "day")
      }

      Rails.cache.write("weather_data_#{zip_code}", cached_data, expires_in: 30.minutes)

      # Call fetch_weather_data again, which should now return cached data
      result = service.fetch_weather_data(zip_code)

      # Verify cached data matches expected structure and values
      expect(result[:data][:current]["temp_f"]).to eq(70.0)
      expect(result[:data][:forecast]["maxtemp_f"]).to eq(80.0)
      expect(result[:cached]).to be_truthy
    end
  end
end