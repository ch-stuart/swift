SwiftApp.service('CampoutUserService', ['$http', function($http) {

  return {
    getCampoutLocations: function() {
      return $http.get('/users/campout_locations');
    },
    getCamperProfile: function() {
      return $http.get('/users/camper_profile');
    },
    shareCamperProfile: function(userid) {
      return $http.put('/users/' + userid, { shareCamperProfile: true });
    }
  };

}]);
