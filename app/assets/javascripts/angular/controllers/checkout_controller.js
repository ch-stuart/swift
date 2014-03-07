/*jshint browser: true, sub:true */
/*global SwiftApp console */

SwiftApp.controller('CheckoutCtrl', ['$scope', 'Cart', 'Postmaster', function($scope, Cart, Postmaster) {

    var VALIDATE_ERROR_MSG = "The address you entered appears to be invalid. Please correct it. Contact info@builtbyswift.com if you are unable to resolve this issue.";
    var RATE_ERROR_MSG = "We were unable to retrieve shipping rates. Try again. If this issue continues to occur contact info@builtbyswift.com.";

    $scope.cart = Cart.loadFromLocalStorage();
    $scope.isShippingReady = false;
    $scope.busy = false;

    $scope['onPickupChanged'] = function() {
        console.log('what is pickup', $scope.pickup);
    };

    $scope['onCalculateShippingCostBtnClicked'] = function() {
        $scope.busy = true;

        var validateParams = {
            line1: $scope.line1,
            city: $scope.city,
            state: $scope.state,
            zip_code: $scope.zip_code
        };

        var rateParams = {
            from_zip: '98107',
            to_zip: $scope.zip_code,
            weight: Cart.getWeight()
        };

        Postmaster
            .validate(validateParams)
            .then(
                function validateSuccessCallback(data) {
                    console.log(data.data);

                    if (data.data.status === 'OK') {
                        rateParams.commercial = !!data.data.commercial;
                        Postmaster
                            .rates(rateParams)
                            .then(
                                function rateSuccessCallback(data) {
                                    $scope.busy = false;
                                    $scope.isShippingReady = true;
                                    $scope.shipping = data.data;

                                    var data = data.data;
                                    var best = data[data.best];
                                    $scope.shipping_service = best.service;
                                    $scope.shipping_charge = best.charge;
                                },
                                function rateErrorCallback(data) {
                                    $scope.busy = false;
                                    console.warn('PostmasterService.rates => Error:', data);
                                    alert(RATE_ERROR_MSG);
                                }
                            );
                    }
                },
                function validateErrorCallback(data) {
                    $scope.busy = false;
                    console.warn('PostmasterService.validate => Error:', data);
                    alert(VALIDATE_ERROR_MSG);
                }
            );
    };

}]);

