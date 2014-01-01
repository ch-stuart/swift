/*global jQuery $ tinycolor setTimeout */
jQuery.fn.color_picker = function() {
    return this.each(function() {

        var $wrapper = $(this);
        var $select = $($wrapper.data('for'));
        var $swatches = $wrapper.find('.color-picker--swatch');
        var $button = $wrapper.find('.color-picker--change');

        $swatches.hide();
        // $swatches.first().show();

        $button.on('click', function() {
            $button.hide();
            $swatches.show();
        });

        $swatches.on('click', function() {
            var $this = $(this);

            var origColor = $this.css('background-color');

            $this.css('background-color', tinycolor.darken(origColor));

            setTimeout(function() {
                $button.show().text('Change Color');
                $swatches.hide();
                $this.show().css('background-color', origColor);

                $select.get(0).selectedIndex = $this.index() + 1;
                $select.trigger('change');
            }, 222);

        });

    });
};
