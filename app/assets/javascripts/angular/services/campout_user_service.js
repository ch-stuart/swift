SwiftApp.service('CampoutUserService', ['$http', '$q', function($http, $q) {

  return {
    getCampoutLocations: function() {
      return $http.get('/users/campout_locations');
    },
    getCamperProfile: function() {
      return $http.get('/users/camper_profile');
    },
    getCamperProfiles: function() {
      return $http.get('/users/camper_profiles');
    },
    shareCamperProfile: function(userid) {
      return $http.put('/users/' + userid, { shareCamperProfile: true });
    }
  };

}]);
