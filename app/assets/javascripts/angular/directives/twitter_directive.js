SwiftApp
  .directive('swTwitter', ['TwitterService', function(twitterService) {

    return {
      scope: {},
      templateUrl: "twitter.html",
      restrict: "E",
      link: function($scope) {
        twitterService
          .getByTag('solstice')
          .success(function(data) {
            $scope.tweets = data;
          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
