SwiftApp
  .directive('swCamperProfile', ['CampoutUserService', function(campoutUserService) {

    return {
      scope: {},
      templateUrl: "camper_profile.html",
      restrict: "E",
      link: function($scope, $elem, $attrs) {

        $scope.share = function() {
          // campoutUserService
        };

        campoutUserService
          .getCamperProfile()
          .success(function(data, status) {
            // profile is public
            if (status === 204) {
              return;
            }

            $scope.data = data;
            $scope.userid = data.userid;
          })
          .error(console.warn);

      }
    };

  }]);
