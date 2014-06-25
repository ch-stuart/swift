/*global angular $ */
var SwiftApp = angular.module('SwiftApp', []);

SwiftApp.config([
  "$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }
]);
