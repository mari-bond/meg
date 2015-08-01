class Weather < ActiveRecord::Base
  scope :by_city,-> (city) { where(city: city) }
  scope :by_country,-> (country) { where(country: country) }
end
