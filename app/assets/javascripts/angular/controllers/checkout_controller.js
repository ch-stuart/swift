/*jshint browser: true, sub:true */
/*global SwiftApp */

SwiftApp.controller('CheckoutCtrl', ['$scope', 'Cart', function($scope, Cart) {

    $scope.cart = Cart.loadFromLocalStorage();

    $scope.$on('cart:products:update', function(e, products) {
        $scope.cart.products = products;
    });

}]);
