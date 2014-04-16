/*global SwiftApp console angular _*/

SwiftApp.service('PackagingService', ['$http', 'CartService', function($http, CartService) {

    var packages = [];

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
    function addPadding(x) {
        return x * 1.2;
    }

    function roundFloat(x) {
        return Math.ceil(x * 100) / 100;
    }

    function getVolumeAndWeight() {
        var f = parseFloat;
        var volume = 0;
        var weight = 0;

        _.each(CartService.products, function(product) {
            volume =+ (f(product.width) * f(product.height) * f(product.length));
            weight =+ f(product.weight);
        });
        return([weight, addPadding(roundFloat(cbrt(volume)))]);
    }

    function getPackages() {
        var side = getVolumeAndWeight()[1];
        var weight = getVolumeAndWeight()[0];

        packages.push({
            weight: weight,
            width: side,
            height: side,
            length: side
        });

        return packages;
    }

    return {
        fit: function() {
            return getPackages();
        }
    };

}]);
