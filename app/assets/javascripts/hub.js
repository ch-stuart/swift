// ...
//= require vue/dist/vue
//= require jquery
//= require jquery_ujs
//= require flash
//= require console
//= require farbtastic/farbtastic
//= require jquery.tabs

/*global remove_fields add_fields $ */

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".group").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}

$.toggleColors = function() {
    $('.color_label').on('click', function(e){
        e.preventDefault();
        $(this).closest('.color_fields').find('.color_boxes').slideToggle();
    });
};

jQuery(function() {
    // https://github.com/pivotal/cacheable-flash
    Flash.transferFromCookies();
    Flash.writeDataTo('alert', $('#js_app-alert'));
    Flash.writeDataTo('notice', $('#js_app-notice'));

});


