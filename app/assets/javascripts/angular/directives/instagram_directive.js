console.log('am i here?');

SwiftApp
  .directive('swInstagram', ['InstagramService', function(instagramService) {

    return {
      scope: {},
      template: "<ul><li style='float:left' ng-repeat='media in mediaItems'><img src='{{ media.thumbnail }}'><br>{{ media.username }}</li></ul>",
      restrict: "E",
      link: function($scope) {
        instagramService
          .getByTag('solstice')
          .success(function(data) {
            $scope.mediaItems = data;
          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
