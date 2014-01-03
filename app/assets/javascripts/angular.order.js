/*global OrderCtrl location console */
function OrderCtrl($scope, $http) {

    var id = location.pathname.split('/')[2];

    $http
        .get('/products/'+ id +'.json')
        .success(function(json) {
            $scope.product = json.product;
        });



    $scope.onChooseColorButtonClicked = function() {
        this.part.showColors = !this.part.showColors;
    };
    $scope.onColorSwatchClicked = function() {
        this.part.selectedColor = this.color;
        this.part.showColors = !this.part.showColors;
    };
    
    $scope.onPartCheckboxClicked = function() {
        console.log(this);
    }


    // $('.color-picker--wrapper').color_picker();
    // $('.color-picker--swatch').tooltip();
    
}
