SwiftApp
  .directive('swFlickrPhoto', ['FlickrService', function(flickrService) {

    return {
      scope: {
          id: '@',
          label: '@',
          name: '@'
      },
      templateUrl: "flickr.html",
      restrict: "E",
      link: function($scope) {
        flickrService
          .getById($scope.id)
          .success(function(data) {
            data.forEach(function(obj) {
              if (obj.label === $scope.label) {
                $scope.photo = obj;
              }
            });

          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
