class WeatherController < ApplicationController
  def index
  end

  def show
    weather_data_service = WeatherDataService.new
    @weather_data = weather_data_service.fetch_realtime_weather(params[:zip_code])

    # TODO - add cached result capture
  end
end
