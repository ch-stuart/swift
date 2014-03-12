/*global SwiftApp console angular */

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

            var defaults = {
                from_zip: '98107',
                from_country: 'US'
            };

            return $http.post('/postmaster/rates', angular.extend(defaults, params));
        }
    };

}]);
