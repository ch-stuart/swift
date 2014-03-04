/*global SwiftApp console*/

SwiftApp.service('Postmaster', ['$http', function($http) {

    return {
        // post 'postmaster/validate'
        validate: function(params) {
            console.log('PostmasterService.validate', params);
            return $http.post('/postmaster/validate', params);
        },
        // match 'postmaster/rates'
        rates: function(params) {
            console.log('PostmasterService.rates', params);
            return $http.post('/postmaster/rates', params);
        }
    };

}]);
