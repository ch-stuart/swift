/*global OrderCtrl location console angular */

// iterate over localStorage
// for (var i = 0; i < localStorage.length; i++){
//     var key = localStorage.key(i);
//     var value = localStorage[key];
//
//     console.log(key, value);
// }


function OrderCtrl($scope, $http) {

    var id = location.pathname.split('/')[2];

    $http
        .get('/products/'+ id +'.json')
        .success(function(json) {
            $scope.product = json.product;

            setupColors.call($scope);
            setupSize.call($scope);
            setupQA.call($scope);
        });

    // Remove colors array if it's empty
    //
    // Why? because Angular thinks that part.colors is truthy
    //
    // @returns nothing
    function setupColors() {
        this.product.parts.forEach(function(part) {
            if (part.colors.length === 0) {
                delete part.colors;
            }
        });
    }

    // Initialize values for Sizes fields
    //
    // @returns nothing
    function setupSize() {
        this.product.selectedSize = this.product.sizes[0];

        // Set this so we can use it later when setting the
        // new title if the user picks a size
        this.product.originalTitle = this.product.title;
        this.product.originalPrice = this.product.price;
    }

    // Initialize values for Question & Answer fields
    //
    // @returns nothing
    function setupQA() {
        // Set this so we can hide/show the input/select
        // based on whether or not it's
        this.product.originalAnswer = this.product.answer;

        // Turn answer choices String into Array
        if (this.product.answer) {
            // Split it up
            this.product.answer = this.product.answer.split(', ');

            // Default
            this.product.selectedAnswer = this.product.answer[0];
        }
    }

    // Save a product purchase. Grab the relevant
    // data to the purchase... Goal is to be able to
    //
    // 1. Tell the customer and shop owner what was
    //    purchased
    // 2. Be able to update the product later (so using
    //    this state, recreate the form)
    //
    // @returns Object savedPurchase
    function savePurchase() {
        var prod = angular.copy($scope.product);
        var save = {};
            save.parts = [];

        function saveIf(prop) {
            if (prod[prop]) {
                save[prop] = prod[prop];
            }
        }

        function savePart(part) {
            delete part.colors;
            delete part.showColors;
            delete part.$$hashKey;

            save.parts.push(part);
        }

        saveIf('answer');
        saveIf('question');
        saveIf('selectedSize');
        saveIf('totalPrice');

        prod.parts
            .filter(function(part) {
                return part.price && part.activated || !part.price && part.selectedColor;
            })
            .forEach(function(part) {
                savePart(part);
            });

        return save;
    }

    // Validate the form
    //
    // @returns isValid (boolean)
    function validateForm() {
        var isValid = true;

        // Reset invalid state
        $scope.product.parts
            .forEach(function(part) {
                delete part.inputIsInvalid;
            });

        // Check for parts which have a price, where
        // the part is active yet there is no selected
        // color and mark them as invalid.
        $scope.product.parts
            .filter(function(part) {
                return part.activated && part.colors && !part.selectedColor;
            })
            .forEach(function(part) {
                isValid = false;
                part.inputIsInvalid = 'input--dirty';
            });

        // Check for parts that have no price, and no
        // selected color
        $scope.product.parts
            .filter(function(part) {
                return !part.price & !part.selectedColor;
            })
            .forEach(function(part) {
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
            return $scope.product.parts
                .filter(function(part) {
                    return part.activated;
                })
                .map(function(part) {
                    return parseFloat(part.price);
                })
                .reduce(function(prev, current) {
                    return prev + current;
                });
        } catch (e) {
            // console.warn(e);
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
            var fabricPrices = $scope.product.parts
                .filter(function(part) {
                    return part.selectedColor && part.selectedColor.price;
                })
                .map(function(part) {
                    return parseFloat(part.selectedColor.price);
                });

                // check for empty [], return 0 if empty
                return fabricPrices.length ? Math.max.apply(null, fabricPrices) : 0;
        } catch(e) {
            // console.warn(e);
            return 0;
        }
    }

    // @returns part having most expensive fabric
    function getMostExpensiveFabric() {
        try {
            return $scope.product.parts
                .filter(function(part) {
                    return part.selectedColor && part.selectedColor.price;
                })
                .sort(function(a, b) {
                    return parseFloat(b.selectedColor.price) - parseFloat(a.selectedColor.price);
                })
                .shift();

        } catch(e) {
            return null;
        }
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

    $scope.onSizeSelectChanged = function() {
        this.product.title = this.product.originalTitle + ' (' + this.product.selectedSize.title + ')';
        this.product.price = this.product.selectedSize.price;
    };

    var isTooltipsInitialized;
    $scope.onChooseColorButtonClicked = function() {
        if (!isTooltipsInitialized) {
            $('.color-picker--swatch').tooltip();
            isTooltipsInitialized = true;
        }
        this.part.showColors = !this.part.showColors;
    };

    $scope.onColorSwatchClicked = function() {

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

    $scope.onPartCheckboxClicked = function() {
        delete this.part.selectedColor;
    };

    $scope.onUserAcknowledgedFabricChargeNotice = function() {
        $scope.product.userAcknowledgedFabricChargeNotice = true;
    };

    $scope.onFormSubmit = function() {
        var isFormValid = validateForm();

        if (isFormValid) {
            $scope.product.totalPrice = calculateTotalPrice();
            var saved = savePurchase();
            console.log(saved);
            console.log('Form is vald. Total price:', $scope.product.totalPrice);

            localStorage.setItem('savedPurchase', JSON.stringify(saved));
        } else {
            console.warn('form is not valid');
        }
    };

}
