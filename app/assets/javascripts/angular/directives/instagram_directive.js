SwiftApp
  .directive('swInstagram', ['InstagramService', function(instagramService) {

    return {
      scope: {
          tag: '@'
      },
      templateUrl: "instagram.html",
      restrict: "E",
      link: function($scope) {
        instagramService
          .getByTag($scope.tag)
          .success(function(data) {
            $scope.mediaItems = data;
          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
