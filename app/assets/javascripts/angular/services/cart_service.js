// TODO clean up this API
// it's messy!

SwiftApp.service('CartService', ['$rootScope', '$http', '$q', function($rootScope, $http, $q) {

    return {
        products: [],
        // Cost of products without shipping, tax, etc.
        price: null,
        // Cost of everything. What we charge the customer.
        total: null,
        totalWithGiftCert: null,
        shippingCharge: null,
        taxRate: null,
        taxAmount: null,
        giftCertRemain: null,
        giftCertApplied: null,
        // Calculates base price, tax amount, shipping charge
        // Broadcasts updates
        // TODO rename
        getPrice: function() {
            var price = 0;
            _.each(this.products, function(product) {
                price = price + ((product.totalPrice * 100) * product.quantity);
            });

            if (this.centsOff) {
                this.originalPrice = price;
                price = price - this.centsOff;
            }

            if (this.percentOff) {
                this.originalPrice = price;
                price = price - (price * (this.percentOff / 100));
            }

            this.price = this.total = price;

            // Adjust total if there is a Tax Rate
            if (this.taxRate) {
                this.taxAmount = this.total * this.taxRate;
                // Needs to be an integer because otherwise
                // Stripe barfs. Can sometimes be a float b/c
                // we're multipying by the tax rate, which
                // may be 0.1283058 or whatever.
                this.total += parseInt(this.taxAmount, 10);
            } else {
                this.taxAmount = null;
            }

            // Adjust total if there is a Shipping Charge
            if (this.shippingCharge) {
                this.total += this.shippingCharge;
            }

            // Adjust total if customer has Gift Certificate
            if (this.giftCertRemain) {
                // If available gift certificate is greater
                // than total... zero out total
                if (this.giftCertRemain >= this.total) {
                    this.giftCertApplied = this.total;
                    this.totalWithGiftCert = 0;
                // If available gift certificate is less
                // than total... use as much as possible
                } else {
                    this.totalWithGiftCert = this.total - this.giftCertRemain;
                    this.giftCertApplied = this.giftCertRemain;
                }
            // Otherwise, reset so the view can update
            } else {
                this.giftCertApplied = this.giftCertRemain = this.totalWithGiftCert = null;
            }

            $rootScope.$broadcast(
                'cart:prices:update',
                this.price,
                this.total,
                this.taxAmount,
                this.taxRate,
                this.shippingCharge,
                this.giftCertRemain,
                this.giftCertApplied,
                this.totalWithGiftCert,
                this.originalPrice);
        },
        setTaxRate: function(rate) {
            if (rate) {
                this.taxRate = parseFloat(rate);
            } else {
                this.taxRate = null;
            }
            this.getPrice();
        },
        setShippingCharge: function(charge) {
            if (charge) {
                this.shippingCharge = parseFloat(charge);
            } else {
                this.shippingCharge = null;
            }
            this.getPrice();
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
            // Copy the newProduct so that we don't
            // affect the product in the controller/view.
            // We will copy properties from `prod` obj on to
            // `save` obj (rather than removing properties we
            // don't want)
            var prod = angular.copy(newProduct),
                save = {},
                localStorageResult;

            save.parts = [];

            // Save a property if it is present
            function saveIf(prop) {
                if (prop in prod) {
                    save[prop] = prod[prop];
                }
            }

            // Save a part on to the product
            function savePart(part) {
                var newPart = {};
                newPart.id = part.id;
                newPart.price = parseFloat(part.price);
                newPart.selectedColor = part.selectedColor;
                newPart.title = part.title;

                save.parts.push(newPart);
            }

            // Save each of these properties on the product
            _.each(['id', 'uniqueId', 'title', 'price', 'totalPrice', 'answer',
              'selectedAnswer', 'kind', 'question', 'selectedSize',
              'mostExpensiveFabric', 'width', 'height', 'length', 'weight',
              'package_type', 'domestic_flat_rate_shipping_charge',
              'international_flat_rate_shipping_charge'], saveIf);

            // Save parts on the product
            _.chain(prod.parts)
                .filter(function(part) {
                    // Only save parts that:
                    // 1. have a price and are activated
                    // 1. don't have a price but do have a color
                    return part.price && part.activated || !part.price && part.selectedColor;
                })
                .each(savePart);

            delete prod.$$hashKey;

            // The user has not had a chance yet to adjust
            // the quantity. Set the default...
            save.quantity = 1;

            // Set a uniqueId so that we can track if the product
            // was already in the cart and the user is editing it
            if (!save.uniqueId) {
                save.uniqueId = SwiftUtils.guid();
            }

            // If this is a product that was already in the cart that
            // we are editing, remove the old version from the cart before
            // adding this one.
            this.products = _.filter(this.products, function(productInCart) {
                return productInCart.uniqueId !== newProduct.uniqueId;
            });

            this.products.push(save);

            this.getPrice();
            localStorageResult = this.saveToLocalStorage();

            $rootScope.$broadcast('cart:products:update', this.products);

            return localStorageResult;
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
        // Set a generic property in the cart.
        set: function(prop, value) {
            this[prop] = value;
            this.saveToLocalStorage();
        },
        loadFromLocalStorage: function() {
            var cartFromLocalStorage,
                cartContents;

            // Check if we have products stored in a cart
            // in localStorage
            try {
                cartFromLocalStorage = localStorage.getItem('cart');
            } catch(ex) {
                SwiftUtils.notifyNoLocalStorage(ex);
                return console.error("Could not access local storage.");
            }

            if (cartFromLocalStorage) {
                // if we do, parse them.
                cartContents = JSON.parse(cartFromLocalStorage);

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

            console.log('CartService#loadFromLocalStorage', cartContents);
            return cartContents;
        },
        // Saves the cart array to localStorage, overwriting whatever
        // was there previously.
        saveToLocalStorage: function() {
            var serialized = JSON.stringify({
                price: this.price,
                total: this.total,
                products: this.products
            });

            console.log('CartService#saveToLocalStorage');

            try {
                localStorage.setItem('cart', serialized);
                return true;
            } catch (ex) {
                SwiftUtils.notifyNoLocalStorage(ex);
                console.error("Could not access local storage.");
                return false;
            }
        },
        // Retrieve gift certificate value
        getGiftCertificateValue: function(guid) {
            var request = $q.defer(),
                that = this;

            $http
                .get('/gift_certificates/show?format=json&guid=' + guid)
                .success(function(response) {
                    that.giftCertRemain = parseFloat(response.gift_certificate.remaining_amount);

                    request.resolve({
                        remainingAmount: that.giftCertRemain
                    });

                    that.getPrice();
                })
                .error(function() {
                    request.reject();
                });

            return request.promise;
        },
        // Null gift certificate value
        nullGiftCertificateValue: function() {
            this.giftCertRemain = null;
            this.getPrice();
        },
        applyCoupon: function(coupon) {
            this.centsOff = this.percentOff = null;

            if (coupon.cents_off) {
                this.centsOff = coupon.cents_off;
            }
            if (coupon.percent_off) {
                this.percentOff = coupon.percent_off;
            }
            this.getPrice();
        },
        nullCoupon: function() {
            this.centsOff = this.percentOff = null;
            this.getPrice();
        }
    };
}]);
