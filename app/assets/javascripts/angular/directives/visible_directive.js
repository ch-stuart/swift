/*global SwiftApp */

SwiftApp
    .directive('swVisible', function() {
        return function (scope, element, attrs) {
            element.css('visibility', 'hidden');

            scope.$watch(attrs.swVisible, function (value) {
                if (value) {
                    element.css('visibility', 'visible');
                } else {
                    element.css('visibility', 'hidden');
                }
            });
        };
    });
