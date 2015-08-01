crtl = ($scope, weatherFactory) ->
  weatherFactory.random().then((data) ->
    $scope.randomWeather = data.weather
  )

  $scope.search = ->
    weatherFactory.search($scope.searchWeather.city, $scope.searchWeather.country).then((data) ->
      $scope.error = null
      $scope.weather = data.weather
    , (failResponse) ->
      $scope.error = 'The city could not be found'
    )

angular
  .module('meg')
  .controller('WeatherController', ['$scope', 'weatherFactory', crtl])