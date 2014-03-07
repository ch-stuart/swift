/*global SwiftApp */

SwiftApp
    .directive('swVisible', function() {
        return function (scope, element, attrs) {
            scope.$watch(attrs.swVisible, function (value) {
                element.css('visibility', 'hidden');

                if (value) {
                    element.css('visibility', 'visible');
                } else {
                    element.css('visibility', 'hidden');
                }
            });
        };
    });
