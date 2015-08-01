require 'rails_helper'

describe WeatherFetcher do
  let(:service) { WeatherFetcher }
  let(:api_weather_path) { '/data/2.5/weather' }
  let(:weather_data) { {"coord"=>{"lon"=>15.64, "lat"=>78.22},
    "weather"=>[{"id"=>800, "main"=>"Clear", "description"=>"Sky is Clear", "icon"=>"01d"}],
    "base"=>"cmc stations",
    "main"=>{"temp"=>289.15, "pressure"=>1020, "humidity"=>41, "temp_min"=>289.15, "temp_max"=>289.15},
    "wind"=>{"speed"=>8.7, "deg"=>120},
    "clouds"=>{"all"=>0},
    "dt"=>1438422600,
    "sys"=>{"type"=>1, "id"=>5326, "message"=>0.0037, "country"=>"SJ", "sunrise"=>-7784984837, "sunset"=>-7784984837},
    "id"=>2729907, "name"=>"Longyearbyen", "cod"=>200
  }}

  before do
    faraday = Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/data/2.5/weather?q=London,uk") { |env| [200, {}, weather_data.to_json] }
        stub.get("/data/2.5/weather?lat=60&lon=70") { |env| [200, {}, weather_data.to_json] }
      end
    end
    service.any_instance.stub(:connection).and_return(faraday)
  end

  it 'should return nil if no city name' do
    fetcher = service.new
    expect(fetcher.fetch).to eq nil
  end

  it 'should fetch weather for London' do
    fetcher = service.new({city_name: 'London', country_name: 'uk'})
    expect(fetcher.fetch).to eq weather_data
  end

  it 'should fetch weather for random place' do
    fetcher = service.new
    fetcher.stub(:random_coords).and_return({ latitude: 60, longitude: 70 })
    expect(fetcher.fetch_random).to eq weather_data
  end
end