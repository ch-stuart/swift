/*global SwiftApp _ console */

SwiftApp.service('PackagingService', ['$http', 'CartService', function($http, CartService) {

    var packages = [];
    var LARGEST_PACKAGE_VOLUME = 4488;

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

    function roundFloat(x) {
        return Math.ceil(x * 100) / 100;
    }

    function getVolumeAndWeight() {
        var f = parseFloat;
        var volume = 0;
        var weight = 0;

        _.each(CartService.products, function(product) {
            volume += (f(getProp(product, 'width')) * f(getProp(product, 'height')) * f(getProp(product, 'length')));
            weight += f(getProp(product, 'weight'));
        });

        return {
            weight: roundFloat(weight),
            volume: volume,
            side: addPadding(roundFloat(cbrt(volume)))
        };
    }

    function getPackages() {
        // Empty the array
        packages.splice(0, packages.length);

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
                weight: weight,
                width: side,
                height: side,
                length: side,
                volume: volume
            });
            package_count--;
        }
        console.log('PackagingService#getPackages', packages.length, packages);
        return packages;
    }

    return {
        fit: function() {
            return getPackages();
        }
    };

}]);
