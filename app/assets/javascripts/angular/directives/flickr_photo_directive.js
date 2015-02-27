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
          .photo($scope.id, $scope.label)
          .success(function(data) {
            $scope.photo = data;
          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
