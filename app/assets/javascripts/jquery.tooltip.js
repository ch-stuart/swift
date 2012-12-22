jQuery.fn.tooltip = function() {
    
    $(document.body).append('<div class=tooltip></div>')
    var $tooltip = $('.tooltip')
    
    var setPosition = function(e) {
        $tooltip.css({
            'top': (e.pageY - 30) + 'px',
            'left': (e.pageX + 10) + 'px' 
        })   
    }
    
    return this.each(function() {

        var $el = $(this)
        
        // Remove the title attr and set it as a data attr.
        // 
        // - Prevents custom tooltip and browser tooltip from
        //   displaying at the same time.
        // - If no JS available, title attr is present
        $el.data('title', $el.attr('title'))
        $el.removeAttr('title')

        $el
            .mouseenter(function(e) {
                setPosition(e)

                $tooltip
                    .text($(this).data('title'))
                    .show()
            })
            .mousemove(setPosition)
            .mouseleave(function() {
                $tooltip.hide()
            })
    })
}
