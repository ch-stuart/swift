SwiftApp
  .directive('swTwitter', ['TwitterService', function(twitterService) {

    return {
      scope: {},
      template: "<ul><li ng-repeat='tweet in tweets'>{{ tweet.text }}</li></ul>",
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
