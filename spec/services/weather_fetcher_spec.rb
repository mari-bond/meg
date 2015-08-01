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
  let(:not_found_data) {{"cod"=>"404", "message"=>"Error: Not found city"}}
  let(:london_weather) { FactoryGirl.build(:weather, city: 'London', country: 'uk', pressure: 1020, humidity: 41,
    temp: 289.15, wind: 8.7, description: "Sky is Clear") }
  let(:random_weather) { FactoryGirl.build(:weather, city: nil, country: nil, pressure: 1020, humidity: 41,
    temp: 289.15, wind: 8.7, description: "Sky is Clear") }
  let(:skip_attrs_on_comparing) {["id", "created_at", "updated_at"]}

  before do
    faraday = Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/data/2.5/weather?q=London,uk") { |env| [200, {}, weather_data.to_json] }
        stub.get("/data/2.5/weather?q=abcde") { |env| [200, {}, not_found_data.to_json] }
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
    expect(fetcher.fetch.attributes.except(*skip_attrs_on_comparing)).to eq(
      london_weather.attributes.except(*skip_attrs_on_comparing))
  end

  it 'should return nil if city is not found' do
    fetcher = service.new({city_name: 'abcde'})
    expect(fetcher.fetch).to eq nil
  end

  it 'should fetch weather for random place' do
    fetcher = service.new
    fetcher.stub(:random_coords).and_return({ latitude: 60, longitude: 70 })
    expect(fetcher.fetch_random.attributes.except(*skip_attrs_on_comparing)).to eq(
      random_weather.attributes.except(*skip_attrs_on_comparing))
  end
end