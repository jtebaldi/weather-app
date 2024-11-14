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
  # Returns realtime and forecast api data and cache status
  def fetch_weather_data(zip_code)
    cache_key = "weather_data_#{zip_code}"

    # Attempt to retrieve data from cache
    cached_data = Rails.cache.read(cache_key)
    return { data: cached_data, cached: true } if cached_data

    # If not cached, fetch real-time and forecast data
    real_time_data = get_weather_data('/current.json', { q: zip_code })
    forecast_data = get_weather_data('/forecast.json', { q: zip_code, days: 1 })

    # Combine data into one result
    combined_data = {
      current: real_time_data["current"],
      forecast: forecast_data.dig("forecast", "forecastday", 0, "day")
    }

    # Store combined data in cache and return
    Rails.cache.write(cache_key, combined_data, expires_in: @cache_duration)
    { data: combined_data, cached: false }
  end

  private 

  # Makes a GET requests to the specified weather API endpoint
  # Params:
  # - endpoint (String): API endpoint to hit (e.g., /current.json or /forecast.json)
  # - params (Hash): Query parameters for the API request
  def get_weather_data(endpoint, params)
    response = self.class.get(endpoint, query: params.merge(key: ENV['WEATHER_API_KEY']))
    response.success? ? response.parsed_response : log_error("Error fetching weather data: #{response.message}")
  end

  # Logs errors encountered during API calls
  def log_error(message)
    Rails.logger.error(message)
    nil
  end

end