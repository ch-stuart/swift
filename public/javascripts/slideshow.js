;(function($){
    function reset() {
        $('.photo').hide();
        $('.description').hide();
    }
    function init() {
        reset();
        $('.photo').first().show();
        $('.description').first().show();

        $('#swift_slideshow_wrapper nav').hide();
    }

    $('nav a.toggle').click(function(e){
        reset();
        var photo = $(this).attr('data-photo');
        var description = $(this).attr('data-description');
        $(description).fadeIn();
        $(photo).fadeIn();
        e.preventDefault();
    });

    var photos_count = $('.photo').size() - 1;

    $('.goto').click(function() {
        reset();
        var idx = $(this).data('goto');
        if (idx < 0) idx = photos_count;
        if (idx > photos_count) idx = 0;

        $(".description").eq(idx).show();
        $(".photo").eq(idx).fadeIn(900);
    });

    $.slideshow = function() {
        init();
    };
})(jQuery);
