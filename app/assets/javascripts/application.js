/*global document jQuery UA window*/
// ...
//= require dollardollar
//= require jquery
//= require flash
//= require jquery.cookie
//= require angular
//= require ngSticky/sticky.js
//= require global_exception_service
//= require console
//= require underscore
//= require ua.js/src/ua
//= require jquery.browser
//= require jquery_ujs
//= require tinycolor
//= require jquery.fitvids
//= require jquery.hero
//= require jquery.lightbox_me
//= require jquery.tabs
//= require jquery.slideshow
//= require angular/app
//= require angular/services/exception_service
//= require angular/directives/visible_directive
//= require angular/services/config_service
//= require angular/services/wa_state_tax_service
//= require angular/services/sale_service
//= require angular/services/packaging_service
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

    // https://github.com/pivotal/cacheable-flash
    Flash.transferFromCookies();

    // Don't show "Signed in successfully.",
    // and don't throw an error if this fails
    try {
        if (Flash.data.notice === "Signed+in+successfully.") {
            delete Flash.data.notice;
        }
        if (Flash.data.notice === "Welcome!+You+have+signed+up+successfully.") {
            delete Flash.data.notice;
        }
    } catch (e) {}

    Flash.writeDataTo('alert', $('#js_app-alert'));
    Flash.writeDataTo('notice', $('#js_app-notice'));
});
