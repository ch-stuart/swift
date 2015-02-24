// ...
//= require console
//= require srcset/srcset
//= require jquery
//= require underscore
//= require unveil/jquery.unveil
//= require jquery.lightbox_me
//= require jquery.fitvids
//= require flexslider/jquery.flexslider
//= require jquery.cookie
//= require flash
//= require matchMedia/matchMedia
//= require ua.js/src/ua
//= require browser_and_feature_checks
//= require dollardollar
//= require angular
//= require ngSticky/sticky.js
//= require afkl-lazy-image/release/lazy-image
//= require angular-flexslider/angular-flexslider.js
//= require global_exception_service
//= require jquery_ujs
//= require tinycolor
//= require jquery.hero
//= require jquery.tabs
//= require jquery.slideshow
//= require angular/app
//= require angular/directives/visible_directive
//= require angular/directives/instagram_directive
//= require leaflet/leaflet
//= require angular-leaflet-directive/dist/angular-leaflet-directive
//= require angular/directives/twitter_directive
//= require angular/services/exception_service
//= require angular/services/config_service
//= require angular/services/coupon_service
//= require angular/services/wa_state_tax_service
//= require angular/services/sale_service
//= require angular/services/packaging_service
//= require angular/services/flat_rate_service
//= require angular/services/place_service
//= require angular/services/cart_service
//= require angular/services/product_service
//= require angular/services/postmaster_service
//= require angular/services/gift_cert_service
//= require angular/services/instagram_service
//= require angular/services/twitter_service
//= require angular/controllers/order_controller
//= require angular/controllers/cart_controller
//= require angular/controllers/cart_status_controller
//= require angular/controllers/checkout_controller
//= require angular/controllers/solstice_controller

jQuery(document).ready(function($) {

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
