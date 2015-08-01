class WeatherSerializer < ActiveModel::Serializer
  attributes :description, :temp, :pressure, :humidity, :wind
end