// Mals docs
// Adding multiple items to your cart
// https://www.mals-e.com/tpv.php?tp=6
    
    
// Behavior for order form
jQuery.fn.orderFormManager = function() {
    
    var notified_customer = false;
    var max_priced_fabric = 0;
    
    $(this)
        .submit(function(e){
            var invalid = false;
                
            $('#order_form select').each(function() {
                console.log('invalid?', $(this).val() );
                if ($(this).val() === "invalid") {
                    invalid = true;
                }
            });
            if (invalid) {
                e.preventDefault();
                $.prompt("Not everything is filled out! Review your order and select a choice for each of the options.");
            }
        })
		// hide color pickers for optional parts until
		// the user has indicated they want this part
		// included
		.find('.input-color-with-optional-part')
		.hide()
		.end()
		// hide/show the color picker for an optional part
		// based on whether or not the checkbox is checked
		.find('.label').click(function() {
			// This is stupid
			var isChecked = $(this).parents('.label-input-pair').find('.part_checkbox').attr('checked');
			var $colorPicker = $(this).parents('.label-input-pair').find('.input-color');

			if (isChecked) {
				$colorPicker.show();
			} else {
				$colorPicker.hide();
			}
		})
		.end()
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
                console.log("parts content " + $('#parts').html());
                increment_count();
            } else {
                // remove the part from the order if they have
                // unchecked the box.
                $('#part_' + $this.data('hash')).remove();
            }
        })
        .end()
        .find('.color_select').change(function() {
            var choices = [],
                max_price = 0,
                $max_option = null,
                opts = null;

            // Empty the #parts
            $('#parts').find('.color_part').remove();
                
            // Scan all color selects
            $('#order_form').find('.color_select').each(function(){
                var $selected_option = $(this).find('option').eq(this.selectedIndex);
                    
                // Find all that have a price option selected
                if ($selected_option.data('price')) {
                    choices.push($selected_option);
                }
            });
            // Find the one with the highest price
            choices.forEach(function($option){
                var new_price = parseInt($option.data('price'), 10);
                if (new_price > max_price) {
                    max_price = new_price;
                    $max_option = $option;
                }
            });
            console.log($max_option);

            // DO NOT CONTINUE if we haven't found anything to add.
            if (!$max_option) return;

            // See if this is the most expensive fabric they've added
            // If so, notify the customer again. I don't know if we want
            // to do this, but we will for now.
            if (parseInt($max_option.data('price'), 10) > max_priced_fabric) {
                max_priced_fabric = parseInt($max_option.data('price'), 10);
                notified_customer = false;
            }
            // Add it to the #parts
            opts = {
                'qty':         '1',
                'count':       $('#order_form').data('count'),
                'hash':        $(this).data('hash'),
                'price':       $max_option.data('price'),
                'product':     $max_option.data('color'),
                'color_hash':  $max_option.data('hash'),
                'is_color':    true
            };
            $('#parts').append(ich.product_tmpl(opts));
                
            console.log("parts content " + $('#parts').html());
                
            if (opts && !notified_customer) {
                // Dump the mustache template into a hidden div
                // so we can grab it back out. $.prompt() is not
                // compatible with ICH.
                $('#buffer').empty().append( ich.prompt_tmpl(opts) );
                $.prompt( $('#buffer').html() );
                notified_customer = true;
            }
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


