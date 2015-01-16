/*global SwiftApp localStorage console _*/

SwiftApp.service('ProductService', [
    '$http',
    'ConfigService',
    'ExceptionService',
    function(
        $http,
        ConfigService,
        ExceptionService) {

    var response;

    function sortParts() {
        console.log('Product#sortParts');
        // Sort by whether or not a part has colors
        if (response.parts) {
            var parts = response.parts;

            response.parts = _.filter(parts, function(part) {
                return part.colors.length;
            }).concat(_.filter(parts, function(part) {
                return !part.colors.length;
            }));
        }
    }

    // Initialize values for Sizes fields
    //
    // @returns nothing
    function setupSizes() {
        console.log('Product#setupSizes');
        if (response.sizes.length) {
            response.selectedSize = response.sizes[0];

            // Set this so we can use it later when setting the
            // new title if the user picks a size
            response.originalTitle = response.title;
            // Not used
            // response.originalPrice = response.price;

            // Set the price on page load
            if (response.selectedSize.price) {
                response.price = response.selectedSize.price;
            } else {
                ExceptionService.report('ProductService#setupSizes: Missing price for default size.', [response]);
            }

            // Must not set wholesale_price to empty string. That will break things.
            if (response.selectedSize.wholesale_price) {
                response.wholesale_price = response.selectedSize.wholesale_price;
            } else {
                ExceptionService.report('ProductService#setupSizes: Missing wholesale price for default size.', [response]);
            }

            console.log('ProductService#setupSizes: We have sizes', response.price);
        }
    }

    // Initialize values for Question & Answer fields
    //
    // @returns nothing
    function setupQA() {
        console.log('Product#setupQA');
        // Set this so we can hide/show the input/select
        // based on whether or not it's
        response.originalAnswer = response.answer;

        // Turn answer choices String into Array
        if (response.answer) {
            // Split it up
            response.answer = response.answer.split(', ');

            // Default
            response.selectedAnswer = response.answer[0];
        }
    }

    function setupPricesForWholesale() {
        if (!ConfigService.get('WS')) return;

        console.log('Product#setupPricesForWholesale');

        // Adjust main price
        response.price = response.wholesale_price;
        response.humane_price = response.wholesale_humane_price;

        // Adjust size prices
        _.each(response.sizes, function(size) {
            if (size.wholesale_price) {
                size.price = size.wholesale_price;
            } else {
                console.log('ProductService#setupPricesForWholesale: No wholesale price available for size', size);
            }
        });
        // Adjust part prices
        _.each(response.parts, function(part) {
            if (part.price) {
                part.price = part.wholesale_price;
            } else {
                console.log('ProductService#setupPricesForWholesale: No wholesale price available for part', part);
            }
        });
        // Adjust fabric prices
        _.each(response.parts, function(part) {
            if (part.colors) {
                _.each(part.colors, function(color) {
                    if (color.price) {
                        color.price = color.wholesale_price;
                    } else {
                        console.log('ProductService#setupPricesForWholesale: No wholesale price available for color', color);
                    }
                });
            }
        });
    }

    return {
        get: function(id) {
            return $http
                .get('/products/'+ id +'.json')
                .success(function(data) {
                    response = data;

                    sortParts();
                    setupSizes();
                    setupQA();
                    setupPricesForWholesale();

                    // if (productToUpdate) {
                    //     setupUpdate.call($scope, productToUpdate);
                    // }
                })
                .error(function(data) {
                    return data;
                });
        },
        setTypes: function() {
            var product_floats = ['price', 'wholesale_price', 'width', 'height', 'length', 'weight'];
            _.each(product_floats, function(f) {
                if (this[f]) {
                    this[f] = parseFloat(this[f]);
                } else {
                    console.warn('ProductService#setTypes: Product missing reqd attr', f, this);
                }
            }, this);

            var part_floats = ['price', 'wholesale_price'];
            _.each(this.parts, function(part) {
                _.each(part_floats, function(f) {
                    if (part[f]) {
                        part[f] = parseFloat(part[f]);
                    } else {
                        console.warn('ProductService#setTypes: Part missing reqd attr', f, part);
                    }
                }, this);

                // _.each(part.colors, function(color) {
                //     _.each(part_floats, function(f) {
                //         if (color[f]) {
                //             color[f] = parseFloat(color[f]);
                //         } else {
                //             console.warn('ProductService#setTypes: Color missing reqd attr', f, color);
                //         }
                //     });
                // });
            }, this);
        },
        setupUpdate: function() {
            var update;

            try {
                update = localStorage.getItem('update');
            } catch (ex) {
                SwiftUtils.notifyNoLocalStorage(ex);
                return console.error("Could not access local storage.");
            }

            if (!update) return;

            update = JSON.parse(update);

            // kill it so we don't get in a loop
            localStorage.removeItem('update');

            // Set this so that when (and if) they re-add it
            // to the cart remove we the previous product.
            this.product.uniqueId = update.uniqueId;

            if (update.selectedAnswer) {
                this.product.selectedAnswer = update.selectedAnswer;
            }

            if (update.selectedSize) {
                this.product.selectedSize = _.filter(this.product.sizes, function(size) {
                    return size.id === update.selectedSize.id;
                })[0];
            }

            if (update.parts) {
                // Loop through all of the parts on the product
                // we are updating
                _.each(update.parts, function(updatePart) {

                    // match up the part from the update product
                    // with the current product
                    var matchingPart = _.filter(this.product.parts, function(part) {
                        return part.id === updatePart.id;
                    })[0];

                    // If the part exists in the update, then it's selected
                    // if it has a price
                    if (matchingPart.price) {
                        matchingPart.activated = true;
                    }
                    // And if it has a selectedColor, find it and set it
                    if (updatePart.selectedColor) {
                        matchingPart.selectedColor = _.filter(matchingPart.colors, function(color) {
                            return color.id === updatePart.selectedColor.id;
                        })[0];
                    }
                }, this);
            }
        }
    };
}]);
