/*global SwiftApp console*/

SwiftApp.service('Postmaster', ['$http', function($http) {

    return {
        // post 'postmaster/validate'
        validate: function(params) {
            console.log('trying to validate');
            return $http.post('/postmaster/validate', params);
        },
        // match 'postmaster/rates'
        rates: function(params) {
            console.log('you may have rates!');
            return $http.post('/postmaster/rates', params);
        }
    };

}]);
