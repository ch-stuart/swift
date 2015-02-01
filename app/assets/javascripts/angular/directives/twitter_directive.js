SwiftApp
  .directive('swTwitter', ['TwitterService', function(twitterService) {

    return {
      scope: {
          tag: '@'
      },
      templateUrl: "twitter.html",
      restrict: "E",
      link: function($scope) {
        twitterService
          .getByTag($scope.tag)
          .success(function(data) {
            $scope.tweets = data;
          })
          .error(function(data) {
            console.error(data);
          });
      }
    };

  }]);
