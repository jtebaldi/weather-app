# WeatherDataService is responsible for interacting with the WeatherAPI (https://www.weatherapi.com/) to fetch
# weather data for a given location based on zip code. This class uses HTTParty to make HTTP requests to the API.
class WeatherDataService
  include HTTParty
  # Set the base API url for 
  base_uri 'https://api.weatherapi.com/v1'  

  def initialize
    @cache_duration = 30.minutes
  end

  # Fetches real-time weather data for a given zip code, with caching
  # Params:
  # - zip_code (String): The zip code for which to retrieve weather data
  def fetch_realtime_weather(zip_code)
    fetch_with_cache("realtime_weather_data_#{zip_code}") do
      get_weather_data('/current.json', { q: zip_code })
    end
  end

  # Fetches forecast weather data for a given zip code, with caching
  # Params:
  # - zip_code (String): The zip code for which to retrieve forecast data
  def fetch_forecast_weather(zip_code)
    fetch_with_cache("forecast_weather_data_#{zip_code}") do
      get_weather_data('/forecast.json', { q: zip_code, days: 1 })
    end
  end

  private 

  # Central method to handle caching logic
  def fetch_with_cache(cache_key)
    cached_data = Rails.cache.read(cache_key)
    return { data: cached_data, cached: true } if cached_data

    # Fetch new data, store in cache, and return
    new_api_data = yield
    Rails.cache.write(cache_key, new_api_data, expires_in: @cache_duration)
    { data: new_api_data, cached: false }
  end

  # Makes a GET request to the specified weather API endpoint with the provided parameters
  def get_weather_data(endpoint, params)
    response = self.class.get(endpoint, query: params.merge(key: ENV['WEATHER_API_KEY']))
    # Parse, store in cache if success, log error if error
    response.success? ? response.parsed_response : log_error("Error fetching weather data: #{response.message}")
  end

  # Logs errors encountered during API calls
  def log_error(message)
    Rails.logger.error(message)
    nil
  end

end