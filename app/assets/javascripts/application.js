/*global document jQuery UA window*/
// ...
//= require console
//= require jquery
//= require ua.js/src/ua
//= require browser_and_feature_checks
//= require matchMedia/matchMedia
//= require dollardollar
//= require jquery.cookie
//= require flash
//= require angular
//= require ngSticky/sticky.js
//= require global_exception_service
//= require underscore
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
//= require angular/services/flat_rate_service
//= require angular/services/place_service
//= require angular/services/cart_service
//= require angular/services/product_service
//= require angular/services/postmaster_service
//= require angular/controllers/order_controller
//= require angular/controllers/cart_controller
//= require angular/controllers/cart_status_controller
//= require angular/controllers/checkout_controller

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
