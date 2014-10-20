/*global SwiftApp _ console angular */

SwiftApp.service('PackagingService', ['$http', 'CartService', function($http, CartService) {

    var packages = [];
    var LARGEST_PACKAGE_VOLUME = 4488;

    // Find out if all products in cart are Flat Rate
    // @returns Boolean
    function allFlatRate() {
        console.log('PackagingService#allFlatRate');
        var productsThatArentFlatRate = _.filter(CartService.products, function(product) {
            var domesticFlatRateCharge = product.domestic_flat_rate_shipping_charge,
                intlFlatRateCharge = product.international_flat_rate_shipping_charge;

            return !angular.isNumber(domesticFlatRateCharge) || !angular.isNumber(intlFlatRateCharge);
        });
        return productsThatArentFlatRate.length === 0;
    }

    // NOTE USPS does not support PAK :(
    // // Find out if all products in cart fit in a PAK
    // // @returns Boolean
    // function allFitPak() {
    //     var productsThatDontFitInPak = _.filter(CartService.products, function(product) {
    //         return product.package_type !== 'PAK'
    //     });
    //     return productsThatDontFitInPak.length === 0;
    // }

    function getProp(p, prop) {
        if (!p[prop]) {
            console.log('PackagingService#getSide: Missing "' + prop + '" for ' + p.title);
            return 8;
        } else {
            return p[prop];
        }
    }

    function cbrt(x) {
        if ('cbrt' in Math) {
            return Math.cbrt(x);
        } else {
            var y = Math.pow(Math.abs(x), 1/3);
            return x < 0 ? -y : y;
        }
    }

    // Add 20% volume to account for padding
    // and the products not perfectly fitting
    function addPadding(volume) {
        return volume * 1.2;
    }

    function addPackagingWeight(weight) {
        if (allFlatRate()) {
            console.log('PackagingService#addPackagingWeight: Add 0lb for packaging weight (Flat Rate)', weight);
        } else {
            console.log('PackagingService#addPackagingWeight: Add 1lb for packaging weight (CUSTOM)', weight);
            weight += 1;
        }
        return roundFloat(weight);
    }

    function roundFloat(x) {
        return Math.ceil(x * 100) / 100;
    }

    // Get total volume and weight for all products in cart
    function getVolumeAndWeight() {
        console.log('PackagingService#getPackages');
        var pF = parseFloat,
            volume = 0,
            weight = 0;

        _.each(CartService.products, function(product) {
            volume += (pF(getProp(product, 'width')) * pF(getProp(product, 'height')) * pF(getProp(product, 'length')));
            weight += pF(getProp(product, 'weight'));
        });

        return {
            weight: roundFloat(weight),
            volume: volume,
            side: roundFloat(addPadding(cbrt(volume)))
        };
    }

    function getPackages() {
        console.log('PackagingService#getPackages');
        // Empty the array
        packages.splice(0, packages.length);

        if (allFlatRate()) {
            packages.allFlatRate = true;
            packages.push({
                weight: 0.01,
                width: 1,
                height: 1,
                length: 1,
                packaging: 'FLAT_RATE'
            });
            console.log('PackagingService#getPackages: All items are flat rate.');
            return packages;
        }

        // Initially we assume we have one package
        var package_count = 1;
        // Get the volume, weight and one side
        var volumeAndWeight = getVolumeAndWeight();

        // Assign these to local vars...
        var weight = volumeAndWeight.weight;
        var side   = volumeAndWeight.side;
        var volume = volumeAndWeight.volume;

        // If our volume exceeds that of our largest box...
        if (volume > LARGEST_PACKAGE_VOLUME) {
            console.log('PackagingService#getPackages: volume exceeds largest box', volume, '>', LARGEST_PACKAGE_VOLUME);
            // Figure out how many of the largest boxes we need
            package_count = Math.ceil(volume / LARGEST_PACKAGE_VOLUME);

            // Adjust weight, volume and side based on this box count
            weight = roundFloat(weight / package_count);
            volume = roundFloat(volume / package_count);
            side = roundFloat(cbrt(volume));
        }

        while (package_count > 0) {
            packages.push({
                weight: addPackagingWeight(weight),
                width: side,
                height: side,
                length: side,
                volume: volume,
                packaging: 'CUSTOM'
            });
            package_count--;
        }
        console.log('PackagingService#getPackages', packages.length, packages);
        return packages;
    }

    return {
        fit: function() {
            console.log('PackagingService#fit');
            return getPackages();
        },
        // FIXME so this is only used to report the weight
        // used when getting rates back to Swift. Currently
        // does not take in to account if PackagingService
        // thought it would require multiple boxes
        getShippingWeight: function() {
            console.log('PackagingService#getShippingWeight');
            return addPackagingWeight(getVolumeAndWeight().weight);
        }
    };

}]);
