/*jshint browser: true, sub:true */
/*global SwiftApp console alert _ */

SwiftApp.controller('CheckoutCtrl', ['$scope', 'Cart', 'Postmaster', 'Country', 'WaStateTaxService', function($scope, Cart, Postmaster, Country, WaStateTaxService) {

    var VALIDATE_ERROR_MSG = "The address you entered appears to be invalid. Please correct it. Contact info@builtbyswift.com if you are unable to resolve this issue.";
    var RATE_ERROR_MSG = "We were unable to retrieve shipping rates. Try again. If this issue continues to occur contact info@builtbyswift.com.";

    $scope.cart = Cart.loadFromLocalStorage();
    $scope.isShippingReady = false;
    $scope.busy = false;
    $scope.countryCodes = Country.get();

    // Default!
    $scope.country = 'US';

    $scope['onPickupChanged'] = function() {
        console.log('are we picking up?', $scope.pickup);
    };

    $scope['onCalculateShippingCostBtnClicked'] = function() {
        $scope.busy = true;

        var validateParams = {
            line1: $scope.line1,
            city: $scope.city,
            state: $scope.state,
            zip_code: $scope.zip_code,
            country: $scope.country
        };

        var rateParams = {
            to_zip: $scope.zip_code,
            to_country: $scope.country,
            weight: Cart.getWeight()
        };

        Postmaster
            .validate(validateParams)
            .then(
                function validateSuccessCallback(response) {
                    var data = response.data;
                    console.log(data);

                    if (data.status === 'OK') {
                        rateParams.commercial = !!data.commercial;

                        if ($scope.country !== 'US') {
                            rateParams.carrier = 'usps';
                        }
                        $scope.intl = !!rateParams.carrier;


                        WaStateTaxService
                            .rate({
                                addr: $scope.line1,
                                city: $scope.city,
                                zip: $scope.zip_code
                            })
                            .then(
                                function taxSuccessCallback(response) {
                                    console.log(response);
                                },
                                function taxErrorCallback(response) {
                                    console.log(response);
                                }
                            );


                        Postmaster
                            .rates(rateParams)
                            .then(
                                function rateSuccessCallback(response) {
                                    console.log('rateSuccessCallback', response);
                                    $scope.rates = [];
                                    $scope.shipping = {};
                                    $scope.busy = false;
                                    $scope.isShippingReady = true;

                                    var data = response.data;

                                    if ($scope.intl) {
                                        var shipping = {
                                            provider: 'USPS',
                                            charge: data.charge,
                                            service: data.service
                                        };
                                        $scope.rates.push(shipping);

                                        // Save this so we can send it to the server
                                        $scope.shipping = shipping;
                                    } else {
                                        _.each(['fedex', 'usps', 'ups'], function(provider) {
                                            // And save it here too...
                                            $scope.shipping = {
                                                charge: data[data.best].charge,
                                                provider: data.best,
                                                service: data[data.best].service
                                            };

                                            // However, for now we want to show the options.
                                            // We may or may not allow the customer to choose.
                                            // I would guess that we will.
                                            if (data[provider]) {
                                                $scope.rates.push({
                                                    best: (data.best === provider),
                                                    charge: data[provider].charge,
                                                    provider: provider,
                                                    service: data[provider].service
                                                });
                                            }
                                        });
                                    }
                                },
                                function rateErrorCallback(response) {
                                    $scope.busy = false;
                                    console.warn('PostmasterService.rates => Error:', response);
                                    alert(RATE_ERROR_MSG);
                                }
                            );
                    }
                },
                function validateErrorCallback(response) {
                    $scope.busy = false;
                    console.warn('PostmasterService.validate => Error:', response);
                    alert(VALIDATE_ERROR_MSG);
                }
            );
    };

}]);

