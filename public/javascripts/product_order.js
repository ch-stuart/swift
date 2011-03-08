;(function($){
    // Behavior for order form
    function handlers() {
        $('input.has_price').change(function() {
            if ($(this).attr("checked")) {
                increment_count();
                
                var html = ich.product_tmpl({
                    'hash':     $(this).data('hash'),
                    'count':    $('#order_form').data('count'),
                    'product':  $(this).data('product'),
                    'price':    $(this).data('price'),
                    'qty':      '1'
                });
                $('#parts').append(html);
            } else {
                $('#part_' + $(this).data('hash')).remove();
            }
        });
        
        $('select.has_price').change(function() {
            var select_hash = $(this).data('hash');
            var idx         = this.selectedIndex;
            var options     = $(this).find('option');
            var option      = options.get(idx);
            var price       = $(option).data('price');
            
            $('#part_' + select_hash).remove();
            
            if (price != "") {
                increment_count();
                var html = ich.product_tmpl({
                    'hash':     select_hash,
                    'count':    $('#order_form').data('count'),
                    'product':  $(option).data('product'),
                    'price':    $(option).data('price'),
                    'qty':      '1'
                });
                $('#parts').append(html);
            }
        });
    }
    
    function increment_count() {
        // get the product current count, increment it.
        var count = parseInt($('#order_form').data('count'));
        $('#order_form').data('count', count + 1);
    }
    
    $.productOrder = function() {
        $(document).ready(function() {
            handlers();
            increment_count();
        });
    };

})(jQuery);
