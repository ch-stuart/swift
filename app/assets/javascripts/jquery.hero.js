/*
 * An animation step manager.
 */

 /*
     ## How to Use

     // Create your runner
     var animRunner = new Runner();

     // Add animation step 1
     animRunner.add(function() {
         // You animation code...
     }, 100)

     // Add animation step 2, this will run
     // 500ms after the first step completes
     animRunner.add(function() {
         // You animation code...
     }, 500)

     // And this will run 1s after the 2nd
     // step completes
     animRunner.add(function() {
         // You animation code...
     }, 1000)

     // Run the steps
     animRunner.run();
 */

var Runner = function(ms) {
    this.ms = ms;
    this.steps = [];
    this.add = function(func, ms) {
        if (!ms) { ms = this.ms; }
        this.steps.push({ 'func': func, 'ms': ms });
    };
    this.run = function() {
        var ms = 0;
        this.steps.forEach(function(step) {
            ms += step.ms;
            setTimeout(function() {
                step.func();
            }, ms);
        });
    };
};

jQuery.fn.hero = function(params) {

	var totalWidth = 0;
	var widths = [];
	var imgCount = 0;
	var imgLoadCount = 0;
	var r = new Runner(3000);

    return this.each(function() {
        var $hero = $(this);
        var $heroScroller = $hero.find('#hero-scroll');
		var $imgs = $heroScroller.find('img');
		
		imgCount = $imgs.size();
		
		function init() {
			$heroScroller
				.find('img')
				.each(function() {
					var imgWidth = $(this).width()
					totalWidth += imgWidth
					widths.push(imgWidth)
				});
			
			$heroScroller
				.css('width', totalWidth + 'px');

			widths.forEach(function(dist, index) {
				r.add(function() {
					var currentScrollDist = Math.abs(parseInt($heroScroller.css('margin-left'), 10));
					var animDist = currentScrollDist + dist;
				
					console.log(animDist);
				
					if (animDist < (totalWidth - $hero.width()) ) {
						$heroScroller.animate({
							'margin-left': -(animDist) + 'px'
						})
					}
				})
			})
			r.run();
		}
		
		$hero.find('.hero-close').click(function() {
			$hero
				.find('.hero-para').hide().end()
				.find('.hero-close').hide().end()
				.find('.hero-open').show();
		});

		$hero.find('.hero-open').click(function() {
			$hero
				.find('.hero-para').show().end()
				.find('.hero-close').show().end()
				.find('.hero-open').hide();
		}).show();
		
		$(window).load(init);
    });
};
