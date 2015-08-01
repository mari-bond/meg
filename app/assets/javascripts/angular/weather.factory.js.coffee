factory = ($resource) ->
  Weather =
    search: (city, country) ->
      $resource("/weather/search").get({ city_name: city, country_name: country }).$promise

    random: ->
      $resource("/weather/random").get().$promise

  Weather
angular
  .module('meg')
  .factory('weatherFactory', ['$resource', factory])