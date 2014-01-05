/*global OrderCtrl location console */

// var app = angular.module('swift', []);
//
// app.directive('validateColor', function() {
//     return {
//         restrict: 'A',
//         require: 'ngModel',
//         link: function (scope, element, attrs, ngModel) {
//             function validate() {
//                 console.log('running validations');
//                 if (scope.part.activated && !scope.part.selectedColor) {
//                     console.log('this is not valid because the part has a price and not selected color');
//                     return false;
//                 }
//                 if (!scope.part.price && !scope.part.selectedColor) {
//                     console.log('this part is not valid because it has no price and no selected color');
//                     return false
//                 }
//                 return true;
//             }
//
//             scope.$watch(function() {
//                 return ngModel.$viewValue;
//             }, validate);
//         }
//     }
// });


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
        this.product.selectedSize = this.product.sizes[0];

        // Set this so we can use it later when setting the
        // new title if the user picks a size
        this.product.originalTitle = this.product.title;
        this.product.originalPrice = this.product.price;
    }

    function setupQA() {
        // Set this so we can hide/show the input/select
        // based on whether or not it's
        this.product.originalAnswer = this.product.answer;

        // Turn answer choices String into Array
        if (this.product.answer) {
            // Split it up
            this.product.answer = this.product.answer.split(', ');

            // Default
            this.product.selectedAnswer = this.product.answer[0];
        }
    }

    function validateForm() {
        var isValid = true;

        // Reset invalid state
        $scope.product.parts
            .forEach(function(part) {
                delete part.inputIsInvalid;
            });

        // Check for parts which have a price, where
        // the part is active yet there is no selected
        // color and mark them as invalid.
        $scope.product.parts
            .filter(function(part) {
                return part.activated && !part.selectedColor;
            })
            .forEach(function(part) {
                isValid = false;
                part.inputIsInvalid = 'input--dirty';
            });

        $scope.product.parts
            .filter(function(part) {
                return !part.price & !part.selectedColor;
            })
            .forEach(function(part) {
                isValid = false;
                part.inputIsInvalid = 'input--dirty';
            });

        return isValid;
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
        this.product.title = this.product.originalTitle + ' (' + this.product.selectedSize.title + ')';
        this.product.price = this.product.selectedSize.price;
    };

    $scope.onChooseColorButtonClicked = function() {
        this.part.showColors = !this.part.showColors;
    };

    $scope.onColorSwatchClicked = function() {
        this.part.selectedColor = this.color;
        this.part.showColors = !this.part.showColors;
        validateForm();
    };

    $scope.onPartCheckboxClicked = function() {
        delete this.part.selectedColor;
    };

    $scope.onFormSubmit = function() {
        var isFormValid = validateForm();

        if (isFormValid) {
            $scope.product.totalPrice = calculateTotalPrice();
            console.log($scope.product.totalPrice);
        } else {
            console.log('form is not valid');
        }
    };

    // $('.color-picker--wrapper').color_picker();
    // $('.color-picker--swatch').tooltip();

}
