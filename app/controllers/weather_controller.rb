# WeatherController handles displaying weather data based on user input.
# It uses the WeatherDataService to fetch real-time weather information for a given zip code.
class WeatherController < ApplicationController
  # index action serves as the landing page where users can input a zip code.
  def index
  end

  def show
    zip_code = params[:zip_code]

    # Server-side validation for 5-digit zip code format
    unless zip_code.match?(/^\d{5}$/)
      flash[:alert] = "Please enter a valid 5-digit zip code."
      return redirect_to root_path
    end

    # Initialize the WeatherDataService, which handles communication with the weather API
    weather_data_service = WeatherDataService.new
    
    # Fetch real-time and forecast weather data for the zip code provided in params
    # Returns a hash containing :data (api realtime weather data) and :cached (boolean)    
    weather_data_result = weather_data_service.fetch_weather_data(params[:zip_code])
    
    if weather_data_result[:data].nil?
      flash[:alert] = "Weather data could not be retrieved. Please try a different zip code."
      return redirect_to root_path
    end
    
    @weather_data = weather_data_result[:data]
    @cached = weather_data_result[:cached]
  end
end
