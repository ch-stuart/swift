/*jshint browser: true, sub:true */
/*global SwiftApp */

SwiftApp.controller('CartStatusCtrl', ['$scope', 'Cart', function($scope, Cart) {

    $scope.cart = Cart.loadFromLocalStorage();

    $scope.$on('cart:products:update', function (e, products) {
        $scope.cart.products = products;
        setMessage();
    });

    // Run on page load and when products update
    function setMessage() {
        // display a stupid message
        if ($scope.cart.products.length === 1) {
            $scope.cart.message = "(You have " + $scope.cart.products.length + " products in your cart)";
        } else if ($scope.cart.products.length > 1) {
            $scope.cart.message = "(You have " + $scope.cart.products.length + " product in your cart)";
        }
    }

    setMessage();

}]);
