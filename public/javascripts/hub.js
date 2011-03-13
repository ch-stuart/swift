;(function($){
    $.toggleColors = function() {
        $('.color_label').click(function(e){
            e.preventDefault();
            $(this).closest('.color_fields').find('.color_boxes').slideToggle();
        });
    };
})(jQuery);

