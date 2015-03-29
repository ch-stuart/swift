/*global angular $ */
var SwiftApp = angular.module('SwiftApp', [
    'sticky',
    'leaflet-directive',
    'afkl.lazyImage',
    'angular-flexslider',
    'ngDialog'
]);

SwiftApp.config([
  "$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }
]);

SwiftApp.directive('scrollOnClick', function() {
  return {
    restrict: 'A',
    link: function(scope, $elm, attrs) {
      var NAV_HEIGHT = 35,
          top = $(attrs.href).offset().top;
          // id = attrs.href.substr(1),
          // target = document.getElementById(id),
          // top = target.getBoundingClientRect().top - NAV_HEIGHT;

      $elm.on('click', function(e) {
        e.preventDefault();
        $('html,body').animate({ scrollTop: top }, 'slow');
      });
    }
  };
});
