class WeatherFetcher
  attr_accessor :city_name, :country_name

  def initialize(args = {})
    args.each do |key, value|
      instance_variable_set "@#{key}", value if respond_to? key
    end
  end

  def fetch
    return unless @city_name
    request({ q: [@city_name, @country_name].compact.join(',') })
  end

  def fetch_random
    by_coords(random_coords)
  end

  private

  def random_coords
    {
      latitude: rand(-90.000000000...90.000000000),
      longitude: rand(-180.000000000...180.000000000)
    }
  end

  def by_coords(coords)
    request({ lat: coords[:latitude], lon: coords[:longitude] })
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