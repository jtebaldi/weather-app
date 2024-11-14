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
    cache_key = "realtime_weather_data_#{zip_code}"
    
    # Check if data is in cache
    cached_data = Rails.cache.read(cache_key)
    if cached_data      
      # Return cached data with the cached flag set to true
      return { data: cached_data, cached: true }
    end

    # If not cached, perform GET request to the current weather endpoint with zip code and API key
    response = self.class.get('/current.json', query: { q: zip_code, key: ENV['WEATHER_API_KEY'] })
    if response.success?
      # Parse, store in cache and return the hash containing weather data
      Rails.cache.write(cache_key, response.parsed_response, expires_in: 30.minutes)
      # Set cached flag to false
      { data: response.parsed_response, cached: false }
    else
      Rails.logger.error("Error fetching realtime weather data: #{response.message}")
      { data: nil, cached: false }
    end

  rescue StandardError => e
    # Log an error if the API call fails and return nil
    Rails.logger.error("Error fetching realtime weather data: #{e.message}")
    nil
  end

  # Fetches forecast weather data for a given zip code.
  # Params:
  # - zip_code (String): The zip code for which to retrieve forecast data.
  def fetch_forecast_weather(zip_code)
    # TODO - Implement forecast fetching logic here
  end
end