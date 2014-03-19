/*global document jQuery UA*/
// ...
//= require console
//= require strftime
//= require underscore
//= require ua.js/src/ua.js
//= require jquery
//= require jquery.browser
//= require jquery_ujs
//= require angular
//= require tinycolor
//= require jquery.checkout
//= require jquery.fitvids
//= require jquery.hero
//= require jquery.lightbox_me
//= require jquery.tabs
//= require jquery.slideshow
//= require angular/application
//= require angular/directives/visible_directive
//= require angular/services/wa_state_tax_service
//= require angular/services/place_service
//= require angular/services/cart_service
//= require angular/services/product_service
//= require angular/services/postmaster_service
//= require angular/controllers/order_controller
//= require angular/controllers/cart_controller
//= require angular/controllers/cart_status_controller
//= require angular/controllers/checkout_controller

jQuery(document).ready(function($) {

    var $root = $(document.documentElement);

    $root.removeClass('nojs');

    if (UA.isMobile()) {
        $root.addClass('is-mobile');
    }
    if (UA.isSafari()) {
        $root.addClass('is-safari');
    }

    if (UA.isIOS()) {
        $root.addClass('is-iOS');
    }

    if ($.browser.msie && $.browser.version <= 10) {
        $(document.body).prepend(
            ['<p class=browsehappy>',
            'You are using an <strong>outdated</strong> browser.',
            '<a href=//browsehappy.com>Upgrade your browser</a>',
            'to improve your experience.</p>'].join('\n')
        );
        $("html").addClass("ie");
    }

    $('#global-menu-btn').click(function() {
        $(this).toggleClass('active');
        $('#global-menu').slideToggle();
    });

    // $(window).on('resize', function() {
    //     $('#width').text( $(document.body).css('width') );
    // });
});
