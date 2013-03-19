/**
 * Equal Heights Plugin
 * Equalize the heights of elements. Great for columns or any elements
 * that need to be the same size (floats, etc).
 * 
 * Version 1.0
 * Updated 12/10/2008
 *
 * Copyright (c) 2008 Rob Glazebrook (cssnewbie.com) 
 *
 * Usage: $(object).equalHeights([minHeight], [maxHeight]);
 * 
 * Example 1: $(".cols").equalHeights(); Sets all columns to the same height.
 * Example 2: $(".cols").equalHeights(400); Sets all cols to at least 400px tall.
 * Example 3: $(".cols").equalHeights(100,300); Cols are at least 100 but no more
 * than 300 pixels tall. Elements with too much content will gain a scrollbar.
 * 
 */

;(function($) {
	$.fn.equalHeights = function(minHeight, maxHeight) {
		tallest = (minHeight) ? minHeight : 0;
		this.each(function() {
			if($(this).height() > tallest) {
				tallest = $(this).height();
			}
		});
		if((maxHeight) && tallest > maxHeight) tallest = maxHeight;
        // fix an issue where if the columns where extremely tall, the height is
        // not high enough
		if (tallest > 300) tallest = tallest + 80;
        // set min-height instead of height. this is less scrollbar prone and 
        // we don't care about IE.
		return this.each(function() {
			$(this).css({
			    "min-height": tallest,
			    "overflow-y":"auto",
			    "overflow-x": "auto"
			});
		});
	}
})(jQuery);


// Changes made to this plugin:
// \ No newline at end of file
// diff --git a/public/javascripts/jquery.equalheights.js b/public/javascripts/jquery.equalheights.js
// index c5733e8..187f2e5 100644
// --- a/public/javascripts/jquery.equalheights.js
// +++ b/public/javascripts/jquery.equalheights.js
// @@ -26,8 +26,17 @@
//              }
//          });
//          if((maxHeight) && tallest > maxHeight) tallest = maxHeight;
// +        // fix an issue where if the columns where extremely tall, the height is
// +        // not high enough
// +        if (tallest > 300) tallest = tallest + 80;
// +        // set min-height instead of height. this is less scrollbar prone and 
// +        // we don't care about IE.
//          return this.each(function() {
// -            $(this).height(tallest).css("overflow","auto");
// +            $(this).css({
// +                "min-height": tallest,
// +                "overflow-y":"auto",
// +                "overflow-x": "auto"
// +            });
//          });
//      }
//  })(jQuery);
// \ No newline at end of file
