jQuery.fn.color_picker = function() {
    return this.each(function() {

        var $wrapper = $(this)
        var $select = $($wrapper.data('for'))
        var $swatches = $wrapper.find('.color-picker--swatch')
        var $button = $wrapper.find('.color-picker--change')

        $swatches.hide()
        $swatches.first().show()

        $button.on('click', function() {
            $button.hide()
            $swatches.show()
        })

        $swatches.on('click', function() {
            $button.show()
            $swatches.hide()
            $(this).show()

            $select.get(0).selectedIndex = $(this).index() + 1
        })

    })
}
