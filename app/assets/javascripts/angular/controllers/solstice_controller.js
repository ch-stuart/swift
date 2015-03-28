SwiftApp.controller('SolsticeCtrl', [
  '$scope',
  '$timeout',
  'ExceptionService',
  'CampoutLocationService',
  function($scope, $timeout, ExceptionService, CampoutLocationService) {

  'use strict';

  var initializeMap,
      initializeHeader,
      initializeWelcome;

  initializeMap = function() {
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

          $scope.camperCount = locs.length;

          locs.forEach(function(loc, idx) {
            var msg = loc.city;

            if (loc.neighbors) {
              msg += "<br>" + loc.neighbors;
              if (loc.neighbors === 1) {
                msg += " neighbor is";
              } else {
                msg += " neighbors are";
              }
              msg += " also attending.";
            }

            markers['m'+idx] = {
              lat: loc.latitude,
              lng: loc.longitude,
              message: msg,
              focus: false,
              draggable: false
            };
          });

          $scope.markers = markers;
        })
        .error(function(data) {
          ExceptionService.report('Failed to get solstice map data', data);
        });
    }
    $timeout(populateMap, 600);
  };

  initializeHeader = function() {
    var $win = $(window),
        $stickyNav = $('.S-nav'),
        stickyNavTop = $stickyNav.offset().top,
        $stickyLogo = $('.S-logo'),
        stickyLogoTop = $stickyLogo.offset().top,
        stickyLogoHeight = parseFloat($stickyLogo.css('height'));

    $(window)
      .scroll(function(e) {
        if (new Date() % 2 === 0 && !window.hasOwnProperty('ontouchstart')) {
          return;
        }

        setTimeout(function () {
          if ($win.scrollTop() > stickyNavTop) {
            if (!$stickyNav.hasClass('S-nav--fixed')) {
              $stickyNav.addClass('S-nav--fixed');
            }
          } else {
            if ($stickyNav.hasClass('S-nav--fixed')) {
              $stickyNav.removeClass('S-nav--fixed');
            }
          }

          if (!UA.isMobile() && $win.scrollTop() > stickyLogoTop + stickyLogoHeight) {
            if (!$stickyLogo.hasClass('S-logo--fixed')) {
              $stickyLogo.addClass('S-logo--fixed');
            }
          } else {
            if ($stickyLogo.hasClass('S-logo--fixed')) {
              $stickyLogo.removeClass('S-logo--fixed');
            }
          }
        }, 111);
      });
  };

  initializeWelcome = function() {
    var loc = window.location.href;

    if (loc.indexOf('/welcome') === -1) {
      return;
    }

    $('html, body').animate({
      scrollTop: $('#map').offset().top - 50
    }, 1200);
  };


  initializeMap();

  $(window).on('load', function() {
    initializeHeader();
    initializeWelcome();
  });
}]);
