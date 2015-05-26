SwiftApp
  .directive('swCamperProfile', ['$log', 'CampoutUserService', function($log, campoutUserService) {

    return {
      scope: {},
      templateUrl: "camper_profile.html",
      restrict: "E",
      link: function($scope, $elem, $attrs) {

        var qaMap = window.camper_qa_map;

        $scope.getQ = function(key) {
          return qaMap[key];
        };

        if ($attrs.profile) {
          $scope.data = JSON.parse($attrs.profile);
          $scope.isPublicProfile = true;
          return;
        }

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
          .error(function(response) {
            console.error(response);
          });

      }
    };

  }]);
