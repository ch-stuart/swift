/*global angular SwiftApp _ localStorage */

SwiftApp.service('Cart', ['$rootScope', function($rootScope) {

    var service = {
        products: [],
        totalPrice: null,
        totalPriceInCents: null,
        calculateTotalPrice: function() {
            var cartTotalPrice = 0;
            _.each(this.products, function(product) {
                cartTotalPrice = cartTotalPrice + (product.totalPrice * product.quantity);
            });
            this.totalPrice = cartTotalPrice;
            this.totalPriceInCents = cartTotalPrice * 100;

            $rootScope.$broadcast('cart:prices:update', [this.totalPrice, this.totalPriceInCents]);
        },
        update: function(updatedProducts) {
            this.products = updatedProducts;
            this.calculateTotalPrice();
            this.saveToLocalStorage();
        },
        // Save a product purchase. Grab the relevant
        // data to the purchase... Goal is to be able to
        //
        // 1. Tell the customer and shop owner what was
        //    purchased
        // 2. Be able to update the product later (so using
        //    this state, recreate the form)
        //
        // @returns Object savedPurchase
        add: function(newProduct) {
            var prod = angular.copy(newProduct);
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

            _.each(['id', 'uniqueId', 'title', 'price', 'totalPrice', 'answer', 'selectedAnswer',
              'question', 'selectedSize', 'mostExpensiveFabric', 'width', 'height', 'length', 'weight'], saveIf);

            _.chain(prod.parts)
                .filter(function(part) {
                    return part.price && part.activated || !part.price && part.selectedColor;
                })
                .each(savePart);

            delete prod.$$hashKey;

            if (!save.uniqueId) {
                save.uniqueId = Date.now();
            }
            save.quantity = 1;

            // If this is a product that was already in the cart that
            // we are editing, remove the old version from the cart before
            // adding this one.
            this.products = _.filter(this.products, function(productInCart) {
                return productInCart.uniqueId !== newProduct.uniqueId;
            });

            this.products.push(save);

            this.calculateTotalPrice();
            this.saveToLocalStorage();

            $rootScope.$broadcast('cart:products:update', this.products);
        },
        // Remove an item from the cart
        //
        // @returns cart products
        remove: function(uniqueId) {
            // Underscore may provide a more efficient means to do this
            this.products = _.filter(this.products, function(product) {
                return product.uniqueId !== uniqueId;
            });
            this.calculateTotalPrice();
            this.saveToLocalStorage();

            $rootScope.$broadcast('cart:products:update', this.products);
        },
        loadFromLocalStorage: function() {
            // Check if we have products stored in a cart
            // in localStorage
            var cartContents = localStorage.getItem('cart');
            if (cartContents) {
                // if we do, parse them.
                cartContents = JSON.parse(cartContents);

                // So either need to never save this
                // or delete it here.
                delete cartContents.message;
                delete cartContents.isNotEmpty;
            }
            // Otherwise, set up a dummy obj
            else {
                cartContents = {};
                cartContents.products = [];
            }

            this.products = cartContents.products;

            return cartContents;
        },
        // Saves the cart array to localStorage, overwriting whatever
        // was there previously.
        saveToLocalStorage: function() {
            localStorage.setItem('cart', JSON.stringify({
                totalPrice: this.totalPrice,
                totalPriceInCents: this.totalPriceInCents,
                products: this.products
            }));
        }
    };
    return service;
}]);
