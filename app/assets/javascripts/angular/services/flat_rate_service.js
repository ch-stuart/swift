SwiftApp.service('FlatRateService', ['CartService', function(CartService) {

    return {
        getShippingCharge: function(type) {
            console.log('FlatRateService#getShippingCharge');

            var products = CartService.loadFromLocalStorage().products,
                key = type + '_flat_rate_shipping_charge',
                max,
                charges,
                totalCharges,
                avgCharge,
                copiedProduct;


            // Iterate through products in cart and find any
            // that have a quantity of > 1 and then duplicate
            // them so that we can properly figure out how
            // many products are in the cart, and as well properly
            // calculate the flat rate shipping charge.
            _.each(products, function(product) {
                if (product.quantity > 1) {
                    console.log('found product with quantity', product.quantity);
                    while (product.quantity > 1) {
                        console.log('copying...');
                        copiedProduct = angular.copy(product);

                        copiedProduct.uniqueId = SwiftUtils.guid();
                        copiedProduct.quantity = 1;
                        products.push(copiedProduct);
                        product.quantity--;
                    }
                }
            });

            console.log(products);

            max = _.max(products, function(product) {
                return product[key];
            });

            if (products.length < 5) {
                return max[key];
            } else {
                charges = _.pluck(products, key);
                totalCharges = _.reduce(charges, function(memo, num) {
                    return memo + num;
                }, 0);
                avgCharge = totalCharges / products.length;

                // Add max flat rate shipping rate + 15% additional for each prod
                return max[key] + ((products.length - 1) * (avgCharge * 0.15));
            }
        }
    };
}]);
