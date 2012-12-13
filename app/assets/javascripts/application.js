// ...
//= require jquery
//= require jquery_ujs
//= require console
//= require jquery.fitvids
//= require jquery.noisy
//= require jquery.impromptu
//= require jquery.color_picker
//= require ICanHaz
//= require slideshow
//= require product_order


jQuery(document).ready(function($) {
    $(document.documentElement).removeClass('nojs');

    // if (document.location.hostname !== "swift.dev") {
        $(document.body).noisy({
            intensity: 0.9, 
            size: 200, 
            opacity: 0.035,
            monochrome: false
        });
    // }
    
    $(window).on('resize', function() {
        $('#width').text( $(document.body).css('width') )
    })
});