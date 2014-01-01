/*global jQuery $ */
jQuery.fn.tabs = function(params) {

    var defaults = {
        'tabs': '.tab',
        'cards': '.card',
        'index': '0'
    };
    params = $.extend(defaults, params);

    return this.each(function() {
        var $tabWrapper = $(this);

        var set = function(idx) {
            $tabWrapper
                .find(params.tabs)
                .removeClass('active')
                .eq(idx)
                .addClass('active');

            $tabWrapper
                .find(params.cards)
                .removeClass('active')
                .eq(idx)
                .addClass('active');
        };

        set(params.index);

        $tabWrapper.on('click', params.tabs, function(e) {
            e.preventDefault();
            set( $(this).index() );
        });

    });
};
