SwiftApp.service('CampoutLocationService', ['$http', function($http) {

  return {
    get: function() {
      return $http.get('/users/campout_locations');
    }
  };

}]);
