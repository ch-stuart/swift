angular.module('sticky', [])

.directive('sticky', ['$timeout', function($timeout){
	return {
		restrict: 'A',
		scope: {
			offset: '@',
			minWidth: '@'
		},
		link: function($scope, $elem, $attrs){
			$timeout(function(){
				var offsetTop = $scope.offset || 0,
					minWidth = $scope.minWidth || 0,
					$window = angular.element(window),
					doc = document.documentElement,
					initialPositionStyle = $elem.css('position'),
					stickyLine,
					scrollTop;


				// Set the top offset
				//
				$elem.css('top', offsetTop+'px');


				// Get the sticky line
				//
				function setInitial(){
					// Cannot use offsetTop, because this gets
					// the Y position relative to the nearest parent
					// which is positioned (position: absolute, relative).
					// Instead, use Element.getBoundingClientRect():
					// https://developer.mozilla.org/en-US/docs/Web/API/element.getBoundingClientRect
					stickyLine = $elem[0].getBoundingClientRect().top - offsetTop;
					checkSticky();
				}

				// Check if the window has passed the sticky line
				//
				function checkSticky(){
					scrollTop = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0);

					if ( scrollTop >= stickyLine && matchMedia("(min-width: "+ $scope.minWidth +"px)").matches ){
						$elem.css('position', 'fixed');
					} else {
						$elem.css('position', initialPositionStyle);
					}
				}


				// Handle the resize event
				//
				function resize(){
					$elem.css('position', initialPositionStyle);
					$timeout(setInitial);
				}


				// Attach our listeners
				//
				$window.on('scroll', checkSticky);
				$window.on('resize', resize);

				setInitial();
			});
		},
	};
}]);
