/*global jQuery setTimeout $ window */
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
    if (!ms) {
      ms = this.ms;
    }
    this.steps.push({
      'func': func,
      'ms': ms
    });
  };
  this.run = function() {
    var ms = 0;
    _.each(this.steps, function(step) {
      ms += step.ms;
      setTimeout(function() {
        step.func();
      }, ms);
    });
  };
};

jQuery.fn.hero = function() {

  var totalWidth = 0;
  var widths = [];
  var imgCount = 0;
  var r = new Runner(3000);
  var link;
  var linkHtml;

  return this.each(function() {
    var $hero = $(this);
    var $heroScroller = $hero.find('#hero-scroll');
    var $imgs = $heroScroller.find('img');

    imgCount = $imgs.size();

    function init() {
      $imgs.each(function() {
        var imgWidth = $(this).width();
        totalWidth += imgWidth;
        widths.push(imgWidth);
      });

      $heroScroller
        .css('width', totalWidth + 'px');

      _.each(widths, function(dist) {
        r.add(function() {
          var currentScrollDist = Math.abs(parseInt($heroScroller.css('margin-left'), 10));
          var animDist = currentScrollDist + dist;

          // console.log(animDist);

          if (animDist < (totalWidth - $hero.width())) {
            $heroScroller.animate({
              'margin-left': -(animDist) + 'px'
            }, {
              duration: 'slow'
            });
          }
        });
      });
      r.run();
    }

    $hero.find('.hero-close,.hero-open').click(function() {
      $hero
        .find('.hero-paras').slideToggle().end()
        .find('.hero-close').toggle().end()
        .find('.hero-open').toggle();
    });

    $hero.find('.hero-open').show();

    link = $hero.find('.hero-heading a').attr('href');
    linkHtml = ' (<a id=hero-link>read more</a>)';

    $hero.find('.hero-paras p:last-child').append(linkHtml);
    $('#hero-link').attr('href', link);


    $(window).load(init);
  });
};
