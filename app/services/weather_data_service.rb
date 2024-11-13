# WeatherDataService is responsible for interacting with the WeatherAPI (https://www.weatherapi.com/) to fetch
# weather data for a given location based on zip code. This class uses HTTParty to make HTTP requests to the API.
class WeatherDataService
  include HTTParty
  # Set the base API url for 
  base_uri 'https://api.weatherapi.com/v1'  

  # Fetches real-time weather data for a given zip code.
  # Params:
  # - zip_code (String): The zip code for which to retrieve weather data.
  def fetch_realtime_weather(zip_code)  
    # TODO - Implement Redis caching logic
    # - Set cache_key
    # - Check and return if data is in cache, set 'cache' to true

    # Perform GET request to the current weather endpoint with zip code and API key
    response = self.class.get('/current.json', query: { q: zip_code, key: ENV['WEATHER_API_KEY'] })
    
    # Parse and return the hash containing weather data if successful, otherwise return nil
    response.parsed_response if response.success?
  rescue StandardError => e
    # Log an error if the API call fails and return nil
    Rails.logger.error("Error fetching weather data: #{e.message}")
    nil
  end

  # Fetches forecast weather data for a given zip code.
  # Params:
  # - zip_code (String): The zip code for which to retrieve forecast data.
  def fetch_forecast_weather(zip_code)
    # TODO - Implement forecast fetching logic here
  end
end