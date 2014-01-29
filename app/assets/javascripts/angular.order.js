/*global OrderCtrl console angular $ localStorage location document alert confirm window */

// iterate over localStorage
// for (var i = 0; i < localStorage.length; i++){
//     var key = localStorage.key(i);
//     var value = localStorage[key];
//
//     console.log(key, value);
// }

function OrderCtrl($scope, $http) {

    $scope.IS_WHOLESALE_USER = window.__iswsu__;

    // Stupid hacky way to do this. Whatevers for now.
    if (document.getElementById('page_products_order')) {
        var id = location.pathname.split('/')[2];
        var productToUpdate = localStorage.getItem('update');

        $http
            .get('/products/'+ id +'.json')
            .success(function(json) {
                $scope.product = json.product;

                setupColors.call($scope);
                setupSize.call($scope);
                setupQA.call($scope);
                if (productToUpdate) {
                    setupUpdate.call($scope, productToUpdate);
                }
            });
    }

    // Check if we have products stored in a cart
    // in localStorage
    var cartContents = localStorage.getItem('cart');
    if (cartContents) {
        // if we do, parse them.
        cartContents = JSON.parse(cartContents);

        // then set them as the .cart object
        $scope.cart = cartContents;

        // So either need to never save this
        // or delete it here.
        delete $scope.cart.showCart;
        delete $scope.cart.message;
        delete $scope.cart.isNotEmpty;

        // display a stupid message
        if (cartContents.products.length === 1) {
            $scope.cart.message = "(You have " + cartContents.products.length + " products in your cart)";
        } else if (cartContents.products.length > 1) {
            $scope.cart.message = "(You have " + cartContents.products.length + " product in your cart)";
        }
        // make the cart pink so we can tell there is stuff
        // in it. hooyah
        if (cartContents.products.length) {
            $scope.cart.isNotEmpty = 'active';
        }
    }
    // Otherwise, set up a dummy obj
    else {
        $scope.cart = {};
        $scope.cart.products = [];
    }

    function setupUpdate(update) {
        console.log('update', JSON.parse(update));
        console.log('this.product', this.product);

        // kill it so we don't get in a loop
        // localStorage.removeItem('update');

        update = JSON.parse(update);

        if (update.selectedAnswer) {
            this.product.selectedAnswer = update.selectedAnswer;
        }

        if (update.selectedSize) {
            var match = this.product.sizes.filter(function(size) {
                return size.id === update.selectedSize.id;
            })[0];

            this.product.selectedSize = match;
        }
    }

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
            var newPart = {};
            newPart.id = part.id;
            newPart.price = part.price;
            newPart.selectedColor = part.selectedColor;
            newPart.title = part.title;

            save.parts.push(newPart);
        }

        ;['id', 'title', 'price', 'totalPrice', 'answer', 'selectedAnswer',
          'question', 'selectedSize', 'mostExpensiveFabric'].forEach(saveIf);

        prod.parts
            .filter(function(part) {
                return part.price && part.activated || !part.price && part.selectedColor;
            })
            .forEach(savePart);

        delete prod.$$hashKey;

        save.uniqueId = Date.now();
        save.quantity = 1;

        return save;
    }

    // Saves the cart array to localStorage, overwriting whatever
    // was there previously.
    function saveCartToLocalStorage() {
        localStorage.setItem('cart', JSON.stringify(angular.copy($scope.cart)));
    }

    function calculateCartTotalPrice() {
        var cartTotalPrice = 0;
        $scope.cart.products.forEach(function(product) {
            cartTotalPrice = cartTotalPrice + (product.totalPrice * product.quantity);
        });
        $scope.cart.totalPrice = cartTotalPrice;
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
            console.log('Form is vald. Total price:', $scope.product.totalPrice);

            if (!$scope.cart) {
                $scope.cart = {};
            }
            if (!$scope.cart.products) {
                $scope.cart.products = [];
            }
            $scope.cart.products.push(saved);

            saveCartToLocalStorage();
            calculateCartTotalPrice();

            $scope.cart.showCart = true;
            window.scrollTo(0, 0);
        } else {
            console.warn('form is not valid');
        }
    };

    $scope.onShopMoreButtonClicked = function() {
        $scope.cart.showCart = false;
    };

    $scope.onCheckOutButtonClicked = function() {
        if ($scope.IS_WHOLESALE_USER && $scope.cart.totalPrice < 500) {
            return alert('Minimum $500 purchase required for wholesale purchasers.');
        }

        alert('should check out now');
    };

    $scope.onGlobalCartButtonClicked = function() {
        calculateCartTotalPrice();
        $scope.cart.showCart = true;
    };

    // Removes the selected item from the cart
    //
    // Updates $scope.cart and the cart stored in localStorage.
    //
    // @returns nothing
    $scope.onRemoveFromCartButtonClicked = function(uniqueId) {
        var shouldRemove = confirm('Are you sure you want to remove this product from your cart? It cannot be undone.');

        if (shouldRemove) {
            $scope.cart.products = $scope.cart.products.filter(function(product) {
                return product.uniqueId !== uniqueId;
            });
            calculateCartTotalPrice();
            saveCartToLocalStorage();
        }
    };

    // Edits the selected item from the cart
    //
    // Does this temporarily remove the item from
    // the cart?
    //
    // @returns nothing
    $scope.onEditFromCartButtonClicked = function(product, uniqueId) {
        $scope.cart.showCart = false;

        // Use indexOf and slice or whatever to remove the product?
        $scope.cart.products = $scope.cart.products.filter(function(product) {
            return product.uniqueId !== uniqueId;
        });

        saveCartToLocalStorage();

        // Save this puppy to localStorage
        localStorage.setItem('update', JSON.stringify(angular.copy(product)))

        // Redirect
        window.location = '/products/' + product.id + '/order'

        // Will check for "edit" item in LS on page load
        // and load form state if need be
    };

    $scope.onProductQuantityChanged = function() {
        $scope.cart.products.forEach(function(product) {
            if (!product.quantity) {
                product.quantity = 1;
            }
        });

        calculateCartTotalPrice();
    };
}
