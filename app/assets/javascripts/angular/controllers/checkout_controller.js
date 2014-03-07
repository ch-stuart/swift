/*jshint browser: true, sub:true */
/*global SwiftApp console */

SwiftApp.controller('CheckoutCtrl', ['$scope', 'Cart', 'Postmaster', function($scope, Cart, Postmaster) {

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
                function successCallback(data) {
                    if (data.data.status === 'OK') {
                        Postmaster
                            .rates(rateParams)
                            .then(
                                function successCallback(data) {
                                    $scope.busy = false;

                                    $scope.isShippingReady = true;

                                    $scope.shipping = data.data;
                                    // var data = data.data;
                                    // var best = data[data.best];
                                    //
                                    // $scope.shipping = {
                                    //     charge: best.charge,
                                    //     service: best.service,
                                    //     provider: data.best
                                    // };
                                },
                                function errorCallback(data) {
                                    $scope.busy = false;
                                    console.warn('PostmasterService.rates => Error:', data);
                                }
                            );
                    }
                },
                function errorCallback(data) {
                    $scope.busy = false;
                    console.warn('PostmasterService.validate => Error:', data);
                }
            );
    };

}]);

