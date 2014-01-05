/*global OrderCtrl location console */
function OrderCtrl($scope, $http) {

    var id = location.pathname.split('/')[2];

    $http
        .get('/products/'+ id +'.json')
        .success(function(json) {
            $scope.product = json.product;

            setupSize.call($scope);
            setupQA.call($scope);
        });

    function setupSize() {
        // Default
        this.product.selectedSize = 'Choose One';

        // Set this so we can use it later when setting the
        // new title if the user picks a size
        this.product.originalTitle = this.product.title;
        this.product.originalPrice = this.product.price;
    }

    function setupQA() {
        // Set this so we can hide/show the input/select
        // based on whether or not it's
        this.product.originalAnswer = this.product.answer;


        // Turn it into an array
        if (this.product.answer) {
            // Default
            this.product.selectedAnswer = 'Choose One';

            // Split it up
            this.product.answer = this.product.answer.split(', ');
        }
    }

    function validateForm() {
        $scope.product.parts
            .forEach(function(part) {
                delete part.inputIsInvalid;
            });

        $scope.product.parts
            .filter(function(part) {
                return part.activated && !part.selectedColor;
            })
            .forEach(function(part) {
                part.inputIsInvalid = 'input-is-invalid';
            });

        console.log($scope.product.parts);
    }

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

                // check for empty [], return 0 if empty
                return fabricPrices.length ? Math.max.apply(null, fabricPrices) : 0;
        } catch (e) {
            // console.warn(e);
            return 0;
        }
    }

    function calculateTotalPrice() {
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
    };

    $scope.onFormSubmit = function() {
        validateForm();

        $scope.product.totalPrice = calculateTotalPrice();

        console.log($scope.product.totalPrice);
    };

    // $('.color-picker--wrapper').color_picker();
    // $('.color-picker--swatch').tooltip();

}
