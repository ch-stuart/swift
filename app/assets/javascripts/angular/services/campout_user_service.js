SwiftApp.service('CampoutUserService', ['$http', '$q', function($http, $q) {

  return {
    getCampoutLocations: function() {
      return $http.get('/users/campout_locations');
    },
    getCamperProfile: function() {
      return $http.get('/users/camper_profile');
    },
    getCamperProfiles: function() {
      // var deferred = $q.defer();

      return $http.get('/users/camper_profiles');
      //   .then(function success(response) {
      //     deferred.resolve(response);
      //   }, function error(response) {
      //     deferred.reject(response);
      //   });
      //
      // return deferred.promise;
    },
    shareCamperProfile: function(userid) {
      return $http.put('/users/' + userid, { shareCamperProfile: true });
    }
  };

}]);
