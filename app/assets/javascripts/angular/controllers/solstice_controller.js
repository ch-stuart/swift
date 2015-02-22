SwiftApp.controller('SolsticeCtrl', ['$scope', function($scope) {

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
        markers: {
            missoulaMarker: {
                lat: 46.872146,
                lng: -113.9939982,
                message: "Jane Doe,<br>Missoula MT",
                focus: false,
                draggable: false
            },
            seattleMarker: {
                lat: 47.6062095,
                lng: -122.3320708,
                message: "Swift Campy,<br>Seattle WA",
                focus: false,
                draggable: false
            }
        },
        tiles: tilesDict.stamenmap,
        defaults: {
            scrollWheelZoom: false
        },
        changeMap: function(map) {
            $scope.tiles = tilesDict[map];
        }
    });

}]);
