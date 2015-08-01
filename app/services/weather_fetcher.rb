class WeatherFetcher
  attr_accessor :city_name, :country_name

  def fetch_for_city
    request({ q: [@city_name, @country_name].compact.join(',') })
  end

  def fetch_random
    latitude = rand(-90.000000000...90.000000000)
    longitude = rand(-180.000000000...180.000000000)
    by_coords(latitude, longitude)
  end

  private

  def by_coords(latitude, longitude)
    request({ lat: latitude, lon: longitude })
  end

  def request(params)
    response = connection.get(weather_data_path, params)
    if response.status == 200
      JSON.parse response.body
    end
  end

  def connection
    options = {
      headers: { 'Accept' => 'application/json' }
    }
    Faraday.new(endpoint, options) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end

  def endpoint
    'http://api.openweathermap.org/'
  end

  def weather_data_path
    "/data/2.5/weather"
  end
end