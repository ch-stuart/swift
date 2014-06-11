// ...
//= require jquery
//= require jquery_ujs
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

// Preview the flickr tag...
// Assumes there is only one flickr tag per page
function createFlickrTagLink() {
    var FLICKR_BASE_URL = '//www.flickr.com/photos/swiftpanniers/tags/';

    if ($(this).val()) {
        $('.js-flickr_tag-link')
            .attr('href', FLICKR_BASE_URL + $(this).val())
            .attr('target', '_new')
            .text('View on Flickr');
    } else {
        $('.js-flickr_tag-link')
        .attr('href', '#')
        .text('');
    }
}

jQuery(function() {
    $('.js-flickr_tag')
        .change(function() {
            createFlickrTagLink.call(this);
        })
        .keypress(function() {
            createFlickrTagLink.call(this);
        })
        .each(function() {
            createFlickrTagLink.call(this);
        });
});
