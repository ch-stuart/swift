jQuery.fn.slideshow = function() {
    return this.each(function() {

        var $wrapper = $(this)
        var $items = $wrapper.find('.slideshow-item')
        var size = $items.size()
        var current = 1

        if (size == 1) {
            $wrapper.find('.slideshow-nav').hide()
            return
        }

        function go(dir) {
            $items.hide()

            if (dir == 'next') {
                if (current + 1 > size) current = 1
                else current++
            } else {
                if (current - 1 == 0) current = size
                else current--
            }
            // eq is 0-based
            $items.eq(current - 1).fadeIn()

        }

        $items.hide().first().fadeIn()

        $wrapper
            .find('.slideshow-nav-item')
            .on('click', function() {
                go( $(this).data('dir') )
            })

    })
}
