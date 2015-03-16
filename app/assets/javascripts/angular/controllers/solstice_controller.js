SwiftApp.controller('SolsticeCtrl', [
  '$scope',
  '$timeout',
  'ExceptionService',
  'CampoutLocationService',
  function($scope, $timeout, ExceptionService, CampoutLocationService) {

  'use strict';

  var tilesDict = {
      openstreetmap: {
          url: "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          options: {
              attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          }
      },
      stamenmap: {
          url: "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png",
          options: {
              attribution: "<a target=_top href=http://maps.stamen.com>Map tiles</a> by <a target=_top href=//stamen.com>Stamen Design</a>, under <a target=_top href=http://creativecommons.org/licenses/by/3.0>CC BY 3.0</a>. Data by <a target=_top href=http://openstreetmap.org>OpenStreetMap</a>, under <a target=_top href=http://creativecommons.org/licenses/by-sa/3.0>CC BY SA</a>."
          }
      }
  };

  angular.extend($scope, {
      kc: {
          lat: 39.0997266,
          lng: -94.5785667,
          zoom: 2
      },
      tiles: tilesDict.stamenmap,
      defaults: {
          scrollWheelZoom: false
      },
      changeMap: function(map) {
          $scope.tiles = tilesDict[map];
      }
  });


  function populateMap() {
    CampoutLocationService
      .get()
      .success(function(locs) {
        var markers = {};

        locs.forEach(function(loc, idx) {
          if (loc.latitude !== null && loc.longitude !== null && loc.city !== null) {
            markers['m'+idx] = {
              lat: loc.latitude,
              lng: loc.longitude,
              message: loc.city,
              focus: false,
              draggable: false
            };
          } else {
            ExceptionService.report('Camper missing map data', loc);
          }
        });

        $scope.markers = markers;
      })
      .error(function(data) {
        ExceptionService.report('Failed to get solstice map data', data);
      });
  }
  $timeout(populateMap, 600);

}]);
