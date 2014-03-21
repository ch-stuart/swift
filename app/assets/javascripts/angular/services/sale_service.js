/*global SwiftApp console angular */

SwiftApp.service('SaleService', ['$http', function($http) {

    return {
        charge: function(params) {
            console.log('SaleService.charge', params);
            return $http.post('/sales/charge', params);
        },
        create: function(params) {
            console.log('SaleService.create', params);
            return $http.post('/sales', params);
        }
    };

}]);
