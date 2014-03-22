/*global angular SwiftApp _ localStorage console */

SwiftApp.service('Cart', ['$rootScope', function($rootScope) {

    var service = {
        products: [],
        price: null,
        shippingCharge: null,
        totalPrice: null,
        taxRate: null,
        taxAmount: null,
        // TODO rename
        getPrice: function() {
            var price = 0;
            _.each(this.products, function(product) {
                price = price + ((product.totalPrice * 100) * product.quantity);
            });

            this.price = this.total = price;

            // Adjust price if there is a taxRate
            if (this.taxRate) {
                this.taxAmount = this.total * this.taxRate;
                this.total += this.taxAmount;
            } else {
                this.taxAmount = null;
            }

            // Adjust price if there is a shippingCharge
            if (this.shippingCharge) {
                this.total += this.shippingCharge;
            }

            $rootScope.$broadcast('cart:prices:update', this.price, this.total, this.taxAmount, this.taxRate, this.shippingCharge);
        },
        setTaxRate: function(rate, waStateResident) {
            if (rate) {
                this.taxRate = parseFloat(rate);
            } else {
                this.taxRate = null;
            }
            this.getPrice();
            this.saveToLocalStorage();
        },
        setShippingCharge: function(charge) {
            if (charge) {
                this.shippingCharge = parseFloat(charge);
            } else {
                this.shippingCharge = null;
            }
            this.getPrice();
            this.saveToLocalStorage();
        },
        getWeight: function() {
            var weight = 0;
            _.each(this.products, function(product) {
                if (product.weight) {
                    weight = weight + parseFloat(product.weight);
                } else {
                    console.warn('CartService: Missing weight for product ', product.title);
                    weight = weight + 5.0;
                }

            });
            return weight;
        },
        update: function(updatedProducts) {
            this.products = updatedProducts;
            this.getPrice();
            this.saveToLocalStorage();

            $rootScope.$broadcast('cart:products:update', this.products);
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

            this.getPrice();
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
            this.getPrice();
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

            // This should have already been deleted
            // But, whatever, for now just re-delete
            // until we care to investigate why it
            // didn't happen already
            _.each(cartContents.products, function(product) {
                delete product.$$hashKey;
            });

            return cartContents;
        },
        // Saves the cart array to localStorage, overwriting whatever
        // was there previously.
        saveToLocalStorage: function() {
            localStorage.setItem('cart', JSON.stringify({
                price: this.price,
                total: this.total,
                shippingCharge: this.shippingCharge,
                taxAmount: this.taxAmount,
                products: this.products
            }));
        }
    };
    return service;
}]);
