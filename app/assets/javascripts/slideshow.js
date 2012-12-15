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
            $items.eq(current - 1).show()

        }

        $items.hide().first().show()

        $wrapper
            .find('.slideshow-nav-item')
            .on('click', function() {
                go( $(this).data('dir') )
            })
            .end()
            .find('.slideshow-photo')
            .on('click', function() {
                var img = new Image()
                img.src = $(this).attr('src')
                img.className = 'litebox'
                img.style.display = 'none'
                $(document.body).append(img)

                var w = $('.litebox').width()
                var h = $('.litebox').height()

                $('.litebox')
                    .css('margin-left', -(w / 2))
                    .css('margin-top', -(h / 2))
                    .show()
                $('.mask').show()
            })
        
        $(document.body).on('click', '.litebox', function() {
            $('.litebox').remove()
            $('.mask').hide()
        })

    })
}
