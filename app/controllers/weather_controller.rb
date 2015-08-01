class WeatherController < ApplicationController
  def index
  end

  def search
    weather = WeatherFetcher.new(params).fetch
    status = weather ? :ok : :bad_request

    render json: weather, status: status
  end

  def random
    render json: WeatherFetcher.new.fetch_random
  end
end