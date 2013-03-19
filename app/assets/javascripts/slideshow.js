/*global jQuery $ UA document Image */
jQuery.fn.slideshow = function() {
    
    return this.each(function() {

        var $wrapper = $(this);
        var $items = $wrapper.find('.slideshow-item');
        var size = $items.size();
        var current = 1;

        if (size === 1) {
            $wrapper.find('.slideshow-nav').hide();
            return;
        }

        function go(dir) {
            $items.hide();

            if (dir == 'next') {
                if (current + 1 > size) current = 1;
                else current++;
            } else {
                if (current - 1 === 0) current = size;
                else current--;
            }
            // eq is 0-based
            $items.eq(current - 1).show();

        }

        $items.hide().first().show();

        $wrapper
            .find('.slideshow-nav-item')
            .on('click', function() {
                go( $(this).data('dir') );
            })
            .end()
            .find('.slideshow-photo')
            .on('click', function() {
                // Just go to the image directly
                // if they're on a mobile device
                if (UA.isMobile()) {
                    document.location = $(this).data('large');
                // Otherwise, show the litebox
                } else {
                    $('.lightbox-img').attr('src', $(this).data('large'));
                    $('.lightbox').lightbox_me({
                        centered: true,
                        closeSelector: '.lightbox-close',
                        overlayCSS: { 'background-color': 'rgba(0,0,0,.7)' }
                    });
                }
            });
        
        if (!UA.isMobile()) {
            $wrapper
                .find('.slideshow-photo').each(function() {
                    var img = new Image();
                    img.src = $(this).data('large');
                });
        }

    });
};
