// ...
//= require jquery
//= require jquery_ujs
//= require console
//= require jquery.equalheights
//= require jquery.noisy
//= require ICanHaz
//= require slideshow
//= require product_order

jQuery(document).ready(function($) {
    $(document.documentElement).removeClass('no-js');
    
    $(document.body).noisy({
        intensity: 0.9, 
        size: 200, 
        opacity: 0.035,
        monochrome: false
    });
});
