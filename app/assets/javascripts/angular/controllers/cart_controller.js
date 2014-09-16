/*jshint browser: true, sub:true */
/*global SwiftApp window alert confirm _ */

SwiftApp.controller('CartCtrl', ['$scope', '$rootScope', 'CartService', function($scope, $rootScope, CartService) {

    $scope.cart = CartService.loadFromLocalStorage();

    $scope.$on('cart:products:update', function(e, products) {
        $scope.cart.products = products;
    });

    // Remove the selected item from the cart
    //
    // @returns nothing
    $scope['onRemoveFromCartButtonClicked'] = function(uniqueId) {
        var shouldRemove = confirm('Are you sure you want to remove this product from your cart? It cannot be undone.');

        if (shouldRemove) {
            CartService.remove(uniqueId);
        }
    };

    // Edits the selected item from the cart
    //
    // Does this temporarily remove the item from
    // the cart?
    //
    // @returns nothing
    $scope['onEditFromCartButtonClicked'] = function(product) {
        // Remove product from cart
        // CHANGED no, don't remove it. If they don't resubmit it to the
        // cart we want to keep this one here. Only remove when they're
        // adding it back...
        // $scope.cart.products = _.filter($scope.cart.products, function(product) {
        //     return product.uniqueId !== uniqueId;
        // });

        CartService.saveToLocalStorage();

        // Save this puppy to localStorage
        try {
            localStorage.setItem('update', JSON.stringify(product));
        } catch(ex) {
            SwiftUtils.notifyNoLocalStorage(ex);
            return console.error("Could not access local storage.");
        }

        // Redirect
        window.location = '/products/' + product.id + '/order';

        // Will check for "edit" item in LS on page load
        // and load form state if need be
    };

    $scope.$on('cart:prices:update', function(e, price, total) {
        $scope.cart.price = price;
        $scope.cart.total = total;
    });

    $scope['onProductQuantityChanged'] = function() {
        _.each($scope.cart.products, function(product) {
            if (!product.quantity) {
                product.quantity = 1;
            }
        });

        CartService.update($scope.cart.products);
    };

    // TODO prefer this element to just be a standard link
    // preventDefault if they don't have enough $$$ in their cart
    $scope['onCheckOutButtonClicked'] = function() {
        if (window.__iswsu__ && $scope.cart.price < 500) {
            return alert('Minimum $500 purchase required for wholesale purchasers.');
        }

        window.location = '/cart/checkout';
    };

}]);
