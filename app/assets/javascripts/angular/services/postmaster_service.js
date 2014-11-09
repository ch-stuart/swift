/*global SwiftApp console angular */

SwiftApp.service('PostmasterService', ['$http', 'ConfigService', 'PackagingService', function($http, ConfigService, PackagingService) {

    return {
        // POST 'postmaster/validate'
        validate: function(params) {
            console.log('PostmasterService#validate', params);
            return $http.post('/postmaster/validate', params);
        },
        // POST 'postmaster/rates'
        rates: function(params) {
            console.log('PostmasterService#rates', params);

            var defaults = {
                from_zip: ConfigService.get('swiftAddress').zip,
                from_country: 'US'
            };

            return $http.post('/postmaster/rates', angular.extend(defaults, params));
        },
        // Worthless endpoint. Bad postmaster.
        // fit: function(params) {
        //     console.log('PostmasterService.fit', params);
        //
        //     return $http.post('/postmaster/fit', params);
        // },
        getDomesticServiceLevels: function() {
            console.log('PostmasterService#getDomesticServiceLevels');
            return {
                'GROUND': 'Ground',
                '3DAY': '3 Day/Priority',
                '2DAY': '2 Day/Priority',
                '1DAY': 'Overnight/Express'
            };
        },
        getIntlServiceLevels: function() {
            console.log('PostmasterService#getIntlServiceLevels');
            var levels = {
                'INTL_SURFACE': '1st Class International',
                'INTL_PRIORITY': 'Priority International',
                'INTL_EXPRESS': 'Express International'
            };

            // INTL_SURFACE is not valid >= 4 pounds
            if (PackagingService.getShippingWeight() >= 4) {
                console.log('PostmasterService: removing INTL_SURFACE b/c weight is greater than 4 pounds');
                delete levels.INTL_SURFACE;
                return levels;
            } else {
                console.log('PostmasterService: keeping INTL_SURFACE');
                return levels;
            }
        }
    };

}]);
