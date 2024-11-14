# README

# Weather Forecast App

This is a Ruby on Rails application that retrieves and displays weather data based on a user-provided zip code. The app uses Redis caching to optimize performance and minimize redundant API calls.

## Features

- Accepts a zip code as input to retrieve current weather and forecast data.
- Caches weather data for 30 minutes to reduce API calls.
- Displays data source status (from cache or API) in the UI.
- Provides a user-friendly form with validation for zip code input.

## Setup

### Prerequisites

- Ruby 3.x
- Rails 7.x
- Redis for caching
- API Key from WeatherAPI (https://www.weatherapi.com/)
- Rspec for testing

### Installation

1. Clone the repository:
`git clone https://github.com/username/weather-forecast-app.git`
`cd weather-forecast-app`

2. Install dependencies:
`bundle install`

3. Set up the database (even though it’s not used, Rails needs a database configured):
`bin/rails db:create`
	
4. Set up environment variables:
Create a .env file and add your WeatherAPI key:
`WEATHER_API_KEY=your_weather_api_key`

5. Configure Redis for caching. Ensure Redis is running and add this configuration to config/environments/development.rb and config/environments/test.rb:
`config.cache_store = :redis_cache_store, { url: ENV[‘REDIS_URL’] || ‘redis://localhost:6379/1’ }`

6. Start the Rails server:
`bin/rails server`

### Usage 

1. Visit the app in your browser at http://localhost:3000.
2. Enter an address with a valid zip code in the input form and submit.
3. The app will display the current temperature, forecast high and low temperatures, and indicate if the data was retrieved from cache or directly from the API.

### Testing

The application includes RSpec tests for:

- Validating current and forecast weather data retrieval.
- Ensuring caching functionality works as expected.
- Mocking API responses to maintain test consistency.

To run the tests:
`bundle exec rspec`

### Caching

The app uses Redis to cache weather data for each zip code for 30 minutes. The cache status is displayed to users so they know if the data is fresh or cached. If Redis is not configured, the app defaults to an in-memory cache.

## Design Considerations

- Data Caching: Data is cached by zip code to minimize API calls, improving performance and handling rate limits.
- Error Handling: Errors in API calls are logged, and the UI displays a message if data cannot be retrieved.
- Environment Variables: Sensitive data like the API key is stored in environment variables for security.

## Project Structure

- app/views/weather/index.html.erb and app/views/weather/show.html.erb: UI for the input form and results display.
- app/controllers/weather_controller.rb: Manages user input and data display.
- app/services/weather_data_service.rb: Handles API requests and caching logic.
- spec/services/weather_data_service_spec.rb: Tests for API and caching functionality.