require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  let(:weather) { FactoryGirl.create(:weather) }

  it {expect(subject).to be_a_kind_of ApplicationController}

  describe 'GET #search' do
    def request
      get :search, { city_name: 'London' }, format: :json
    end

    it 'success' do
      WeatherFetcher.stub_chain(:new, :fetch).with({city_name: 'London'}).with(no_args).and_return weather
      weather_json = WeatherSerializer.new(weather).to_json
      request

      expect(response.body).to eq weather_json
      expect(response).to have_http_status(:ok)
    end

    it 'fail' do
      WeatherFetcher.stub_chain(:new, :fetch).with({city_name: 'London'}).with(no_args)
      request

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET #random' do
    def request
      get :random, format: :json
    end

    it 'success' do
      WeatherFetcher.stub_chain(:new, :fetch_random).with(no_args).with(no_args).and_return weather
      weather_json = WeatherSerializer.new(weather).to_json
      request

      expect(response.body).to eq weather_json
      expect(response).to have_http_status(:ok)
    end
  end
end