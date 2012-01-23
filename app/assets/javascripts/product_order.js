(function($){
    // Behavior for order form
    $.productOrder = function() {
        $('#order_form')
            .find('.part_checkbox').change(function() {
                var $this = $(this);
                if ($this.attr("checked")) {
                    $('#parts').append(
                        ich.product_tmpl({
                            'qty':      '1',
                            'count':    $('#order_form').data('count'),
                            'hash':     $this.data('hash'),
                            'price':    $this.data('price'),
                            'product':  $this.data('product')
                        })
                    );
                    increment_count();
                } else {
                    // remove the part from the order if they have
                    // unchecked the box.
                    $('#part_' + $this.data('hash')).remove();
                }
            })
            .end()
            .find('.color_select').change(function() {
                var has_been_added_already = false;
                var $option = $(this).find('option').eq(this.selectedIndex);
                
                // do not proceed if the color does not have a price.
                if (!$option.data('price')) return;

                var opts = {
                    'qty':         '1',
                    'count':       $('#order_form').data('count'),
                    'hash':        $(this).data('hash'),
                    'price':       $option.data('price'),
                    'color':       $option.data('color'),
                    'color_hash':  $option.data('hash')
                };
                // remove the part, add it again below
                $('#part_' + opts.hash).remove();
                $('#parts > div').each(function(idx, part){
                    if ($(part).data('color-hash') === opts.color_hash) {
                        has_been_added_already = true; }
                });
                // if they fabric has already been added (a fabric is 
                // charged only once per bag), don't add it again.
                if (has_been_added_already) return;
                
                $('#parts').append( ich.product_tmpl(opts) );
                $.prompt("Including &ldquo;" + opts.color + "&rdquo; adds a charge of $" + opts.price + " to this bag.");
                increment_count();
            });

        // we increment the count, but we don't decrement. what the heck.
        function increment_count() {
            // get the product current count, increment it.
            var count = parseInt($('#order_form').data('count'), 10);
            $('#order_form').data('count', count + 1);
        }

        increment_count();
    };
})(jQuery);
