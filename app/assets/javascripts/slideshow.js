;(function($){
	var $box = $('#swift_slideshow_wrapper');
	
    function reset() {
        $box.find('.photo').hide();
        $box.find('.description').hide();
    }
    function init() {
        reset();
        $box.find('.photo').first().show();
        $box.find('.description').first().show();

        $box.find('nav').hide();
    }

    $('nav a.toggle').click(function(e){
        reset();
        var photo = $(this).data('photo');
        var description = $(this).data('description');
        $(description).fadeIn();
        $(photo).fadeIn();
        e.preventDefault();
    });

    var photos_count = $box.find('.photo').size() - 1;

    $box.find('.goto').click(function() {
        reset();
        var idx = $(this).data('goto');
        if (idx < 0) idx = photos_count;
        if (idx > photos_count) idx = 0;

        $box.find(".description").eq(idx).show();
        $box.find(".photo").eq(idx).fadeIn(900);
    });

    $.slideshow = function() {
        init();
    };
})(jQuery);
