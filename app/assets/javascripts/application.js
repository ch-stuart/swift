// ...
//= require jquery
//= require jquery_ujs
//= require console
//= require jquery.equalheights
//= require jquery.noisy
//= require jquery.impromptu
//= require jquery-selectBox/jquery.selectBox
//= require ICanHaz
//= require slideshow
//= require product_order

jQuery(document).ready(function($) {
    $(document.documentElement).removeClass('no-js');

    if (document.location.hostname !== "localhost") {
        $(document.body).noisy({
            intensity: 0.9, 
            size: 200, 
            opacity: 0.035,
            monochrome: false
        });
    }
});