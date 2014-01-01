// ...
//= require array.foreach
//= require ua
//= require jquery
//= require jquery.browser
//= require jquery_ujs
//= require tinycolor
//= require console
//= require jquery.fitvids
//= require jquery.noisy
//= require jquery.impromptu
//= require jquery.color_picker
//= require jquery.hero
//= require jquery.lightbox_me
//= require jquery.tooltip
//= require jquery.tabs
//= require ICanHaz
//= require slideshow
//= require product_order

jQuery(document).ready(function($) {

    var $root = $(document.documentElement);

    $root.removeClass('nojs');

    if (UA.isMobile()) {
        $root.addClass('is-mobile');
    }
    if (UA.isSafari()) {
        $root.addClass('is-safari');
    }

    $('#global-menu-btn').click(function() {
        $(this).toggleClass('active');
    	$('#global-menu').slideToggle();
    });

    if (document.location.hostname !== "swift.dev") {
        $(document.body).noisy({
            intensity: 0.9,
            size: 200,
            opacity: 0.035,
            monochrome: false
        });
    }

    // $(window).on('resize', function() {
    //     $('#width').text( $(document.body).css('width') );
    // });
});
