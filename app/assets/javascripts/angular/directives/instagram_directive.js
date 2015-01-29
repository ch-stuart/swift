SwiftApp
  .directive('swInstagram', ['InstagramService', function(instagramService) {

    return {
      scope: {},
      templateUrl: "instagram.html",
      restrict: "E",
      link: function($scope) {
        instagramService
          .getByTag('montana')
          .success(function(data) {
            $scope.mediaItems = data;
          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
