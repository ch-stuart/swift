/*global SwiftApp console angular */

// API Docs:
// http://dor.wa.gov/Content/FindTaxesAndRates/RetailSalesTax/DestinationBased/ClientInterface.aspx
//
// Endpoint returns XML. :(
//
// params
//
// addr, city, zip, output
//

SwiftApp.service('WaStateTaxService', ['$http', function($http) {

    var defaults = {
        output: 'xml'
    };

    return {
        rate: function(params) {
            console.log('WaStateTaxService.rate', params);
            return $http.post('/wa_state_taxes/rate', angular.extend(defaults, params));
        }
    };

}]);
