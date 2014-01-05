/*global OrderCtrl location console */
function OrderCtrl($scope, $http) {

    var id = location.pathname.split('/')[2];

    $http
        .get('/products/'+ id +'.json')
        .success(function(json) {
            $scope.product = json.product;

            // Initialize this as "null", otherwise
            // angular will set the first <option>
            // in the <select> as <option></option>,
            // and then <option>Choose one</option>
            // will not show up.
            $scope.product.selectedSize = 'Choose One';
            // Set this so we can use it later when setting the
            // new title if the user picks a size
            $scope.product.originalTitle = $scope.product.title;
            $scope.product.originalPrice = $scope.product.price;
        });

    // Sum of prices for parts with prices
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

    // You only pay once for fabric per product. You
    // pay for the most expensive fabric. Therefore
    // if your fabric choices were [$12, $99, $2], you
    // would be charged $99 for your fabric choice.
    function calculateTotalPriceOfFabrics() {
        try {
            var fabricPrices = $scope.product.parts
                .filter(function(part) {
                    return part.selectedColor;
                })
                .filter(function(part) {
                    return part.selectedColor.price;
                })
                .map(function(part) {
                    return parseFloat(part.selectedColor.price);
                });

                return Math.max.apply(null, fabricPrices);
        } catch (e) {
            // console.warn(e);
            return 0;
        }
    }

    function calculateTotalPrice() {
        var totalPrice;

        // Sum of:
        //
        // 1. Product Price, if there is no size, or Size Price if there is a size
        // 2. Sum of all selected parts
        // 3. Highest-priced fabric choice

        return calculateTotalPriceOfParts() + calculateTotalPriceOfFabrics() + parseFloat($scope.product.price);
    }

    $scope.onSizeSelectChanged = function() {
        if (this.product.selectedSize) {
            if (this.product.selectedSize === "Choose One") {
                this.product.title = this.product.originalTitle;
                this.product.price = this.product.originalPrice;
            } else {
                this.product.title = this.product.originalTitle + ' (' + this.product.selectedSize.split('::')[0] + ')';
                this.product.price = this.product.selectedSize.split('::')[1];
            }
        }
    };

    $scope.onChooseColorButtonClicked = function() {
        this.part.showColors = !this.part.showColors;
    };
    $scope.onColorSwatchClicked = function() {
        this.part.selectedColor = this.color;
        this.part.showColors = !this.part.showColors;
    };

    $scope.onPartCheckboxClicked = function() {
        delete this.part.selectedColor;
    }

    $scope.onFormSubmit = function() {
        $scope.totalPrice = calculateTotalPrice();

        console.log($scope.totalPrice);
    };

    // $('.color-picker--wrapper').color_picker();
    // $('.color-picker--swatch').tooltip();

}
