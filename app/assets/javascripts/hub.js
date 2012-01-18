// ...
//= require jquery
//= require jquery_ujs
//= require console
//= require farbtastic/farbtastic

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".group").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

;(function($){
    $.toggleColors = function() {
        $('.color_label').live('click', function(e){
            e.preventDefault();
            $(this).closest('.color_fields').find('.color_boxes').slideToggle();
        });
    };
})(jQuery);