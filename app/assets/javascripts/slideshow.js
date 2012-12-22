jQuery.fn.slideshow = function() {
    
    function sizeLitebox($litebox) {
        var w = $litebox.width()
        var h = $litebox.height()

        $litebox
            .css({
                'margin-left':  -(w / 2),
                'margin-top': -(h / 2)
            })
    }

    return this.each(function() {

        var $wrapper = $(this)
        var $items = $wrapper.find('.slideshow-item')
        var size = $items.size()
        var current = 1

        if (size === 1) {
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
                // Just go to the image directly
                // if they're on a mobile device
                if (UA.isMobile()) {
                    document.location = $(this).data('large')
                // Otherwise, show the litebox
                } else {
                    var img = new Image()
                    img.src = $(this).data('large')
                    img.className = 'litebox'
                    img.style.display = 'none'
                    
                    $(document.body).append(img)

                    sizeLitebox( $('.litebox') )

                    $('.litebox, .mask').show()

                    $(document.body).addClass('stop-scrolling')
                    
                    window.scrollTo(0,0)
                }
            })
            
        $wrapper
            .find('.slideshow-photo').each(function() {
                var img = new Image()
                img.src = $(this).data('large')
            })
        
        $(document.body).on('click', '.litebox', function() {
            $('.litebox').remove()
            $('.mask').hide()
            $(document.body).removeClass('stop-scrolling')
        })
        
        $(window).on('resize', function() {
            if ($('.litebox').size() === 0) return;

            sizeLitebox($('.litebox'))
        })

    })
}
