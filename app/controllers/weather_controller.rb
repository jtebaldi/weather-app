# WeatherController handles displaying weather data based on user input.
# It uses the WeatherDataService to fetch real-time weather information for a given zip code.
class WeatherController < ApplicationController
  # index action serves as the landing page where users can input a zip code.
  def index
  end

  def show
    # Initialize the WeatherDataService, which handles communication with the weather API
    weather_data_service = WeatherDataService.new
    
    # Fetch real-time and forecast weather data for the zip code provided in params
    # Returns a hash containing :data (api realtime weather data) and :cached (boolean)    
    weather_data_result = weather_data_service.fetch_weather_data(params[:zip_code])
    @weather_data = weather_data_result[:data]
    @cached = weather_data_result[:cached]
  end
end
