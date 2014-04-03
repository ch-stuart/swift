/*global SwiftApp console angular */

SwiftApp.service('PostmasterService', ['$http', 'ConfigService', function($http, ConfigService) {

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
                from_zip: ConfigService.get('swiftAddress').zip,
                from_country: 'US'
            };

            return $http.post('/postmaster/rates', angular.extend(defaults, params));
        },
        getDomesticServiceLevels: function() {
            return {
                'GROUND': 'Ground',
                '3DAY': '3 Day/Priority',
                '2DAY': '2 Day/Priority',
                '1DAY': 'Overnight/Express'
            };
        },
        getIntlServiceLevels: function() {
            return {
                'INTL_SURFACE': '1st Class International',
                'INTL_PRIORITY': 'Priority International',
                'INTL_EXPRESS': 'Express International'
            };
        }
    };

}]);
