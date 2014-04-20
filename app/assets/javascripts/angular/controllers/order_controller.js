/*jshint browser: true, sub:true */
/*global SwiftApp alert location window _ console */

SwiftApp.controller('OrderCtrl', [
    '$scope',
    '$http',
    'CartService',
    'ProductService',
    'ExceptionService'
    function(
        $scope,
        $http,
        CartService,
        ProductService,
        ExceptionService) {

    $scope.cart = CartService.loadFromLocalStorage();

    ProductService
        .get(location.pathname.split('/')[2])
        .then(successCallback, errorCallback);

    function successCallback(response) {
        $scope.product = response.data.product;

        // Change currency strings into floats
        ProductService.setTypes.call($scope.product);

        // Updates the form so we can edit a product from
        // the cart
        ProductService.setupUpdate.call($scope);
    }

    function errorCallback(data) {
        ExceptionService.report('OrderCtrl#errorCallback', JSON.stringify(data));
        alert('An error occurred. Try reloading page.');
    }

    $scope.$on('cart:products:update', function(e, products) {
        $scope.cart.products = products;
    });

    // Validate the form
    //
    // @returns isValid (boolean)
    function validateForm() {
        var isValid = true;

        // Reset invalid state
        _.each($scope.product.parts, function(part) {
            delete part.inputIsInvalid;
        });

        // Check for parts which have a price, where
        // the part is active yet there is no selected
        // color and mark them as invalid.
        _.chain($scope.product.parts)
            .filter(function(part) {
                return part.activated && part.colors.length && !part.selectedColor;
            })
            .each(function(part) {
                isValid = false;
                part.inputIsInvalid = 'input--dirty';
            });

        // Check for parts that have no price, and no
        // selected color
        _.chain($scope.product.parts)
            .filter(function(part) {
                return !part.price & !part.selectedColor;
            })
            .each(function(part) {
                isValid = false;
                part.inputIsInvalid = 'input--dirty';
            });

        return isValid;
    }

    // Sum of prices for parts with prices
    //
    // @returns total price of active parts
    function calculateTotalPriceOfParts() {
        try {
            return _.chain($scope.product.parts)
                .filter(function(part) {
                    return part.activated;
                })
                .map(function(part) {
                    return parseFloat(part.price);
                })
                .reduce(function(prev, current) {
                    return prev + current;
                })
                .value();
        } catch (e) {
            console.warn(e);
            return 0;
        }
    }

    // Get Price of Most Expensive Fabric
    //
    // You only pay once for fabric per product. You
    // pay for the most expensive fabric. Therefore
    // if your fabric choices were [$12, $99, $2], you
    // would be charged $99 for your fabric choice.
    //
    // @returns most expensive fabrice price (number)
    function calculateTotalPriceOfFabrics() {
        try {
            var fabricPrices = _.chain($scope.product.parts)
                .filter(function(part) {
                    return part.selectedColor && part.selectedColor.price;
                })
                .map(function(part) {
                    return parseFloat(part.selectedColor.price);
                })
                .value();

                // check for empty [], return 0 if empty
                return fabricPrices.length ? Math.max.apply(null, fabricPrices) : 0;
        } catch(e) {
            // console.warn(e);
            return 0;
        }
    }

    // @returns part having most expensive fabric
    function getMostExpensiveFabric() {
        var maxPart = null;

        var partsWithPrices = _.filter($scope.product.parts, function(part) {
            return part.selectedColor && part.selectedColor.price;
        });

        if (partsWithPrices.length) {
            maxPart = _.max(partsWithPrices, function(part) {
                return parseFloat(part.selectedColor.price);
            });
        }

        return maxPart;
    }

    // @returns total price for product
    function calculateTotalPrice() {
        // Sum of:
        //
        // 1. Product Price, if there is no size, or Size Price if there is a size
        // 2. Sum of all selected parts
        // 3. Highest-priced fabric choice

        return calculateTotalPriceOfParts() + calculateTotalPriceOfFabrics() + parseFloat($scope.product.price);
    }

    $scope['onSizeSelectChanged'] = function() {
        this.product.title = this.product.originalTitle + ' (' + this.product.selectedSize.title + ')';
        this.product.price = parseFloat(this.product.selectedSize.price);
    };

    $scope['onChooseColorButtonClicked'] = function() {
        this.part.showColors = !this.part.showColors;
    };

    $scope['onColorSwatchClicked'] = function() {

        this.part.selectedColor = this.color;
        this.part.showColors = !this.part.showColors;

        if (getMostExpensiveFabric()) {
            var newPart = getMostExpensiveFabric();

            if ($scope.product.mostExpensiveFabric) {
                var oldPart = $scope.product.mostExpensiveFabric;
                var newPartPrice = parseFloat(newPart.selectedColor.price);
                var oldPartPrice = parseFloat(oldPart.selectedColor.price);

                if (newPartPrice > oldPartPrice) {
                    $scope.product.mostExpensiveFabric = newPart;
                }
            } else {
                $scope.product.mostExpensiveFabric = newPart;
            }
        } else {
            delete $scope.product.mostExpensiveFabric;
        }
        // TODO update validation so when the user
        // corrects the issue the error state goes
        // away. the key thing is that we actually
        // only want to adjust this elements error
        // state, not all of them. well, we don't want
        // to mark untouched fields as invalid just
        // because we're ... whatever
    };

    $scope['onPartCheckboxClicked'] = function() {
        delete this.part.selectedColor;
    };

    $scope['onUserAcknowledgedFabricChargeNotice'] = function() {
        $scope.product.userAcknowledgedFabricChargeNotice = true;
    };

    $scope['onFormSubmit'] = function() {
        if (validateForm()) {
            $scope.product.totalPrice = calculateTotalPrice();

            if (!$scope.product.totalPrice) {
                ExceptionService.report('OrderCtrl#onFormSubmit: Could not get total price', JSON.stringify($scope.product));
            }

            CartService.add($scope.product);

            window.location = '/cart';
        }
    };

}]);




