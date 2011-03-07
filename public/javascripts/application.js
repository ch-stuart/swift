// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".group").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

jQuery(document).ready(function($) {
    $('html').removeClass('no-js');
    if ($(document.body).hasClass('hub')) {
        $(document.documentElement).addClass('hub');
    }
    
    $('body').noisy({
        intensity: 0.9, 
        size: 200, 
        opacity: 0.035,
        monochrome: false
    });
});
