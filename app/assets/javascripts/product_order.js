/*global jQuery $ ich console */

// Mals docs
// Adding multiple items to your cart
// https://www.mals-e.com/tpv.php?tp=6

// Behavior for order form
jQuery.fn.orderFormManager = function() {

    var notified_customer = false;
    var max_priced_fabric = 0;
    var $form = $(this);

    // we increment the count, but we don't decrement. what the heck.
    function increment_count() {
        // get the product current count, increment it.
        var count = parseInt($form.data('count'), 10);
        $form.data('count', count + 1);
    }
    increment_count();

    // hide color pickers for optional parts until
    // the user has indicated they want this part
    // included
    $form
        .find('.input-color-with-optional-part')
        .hide();

    // hide/show the color picker for an optional part
    // based on whether or not the checkbox is checked
    $form
        .find('.label').click(function() {
            // This is stupid
            var isChecked = $(this).parents('.label-input-pair').find('.input-checkbox').prop('checked');
            var $colorPicker = $(this).parents('.label-input-pair').find('.input-color-with-optional-part');

            if (isChecked) {
                $colorPicker.show();
            } else {
                $colorPicker.hide();
            }
        });

    // Manage add-on parts
    $form
        .find('.input-checkbox').change(function() {
            var $this = $(this);
            if ($this.prop('checked')) {
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
            console.log("=> parts", $('#parts').html());
        });

    // Add remove error class to size pickers
    $form
        .find('.select-size').change(function() {
            var $label = $(this).parents('.label-input-pair').find('.label');
            if ($(this).val() === "invalid") {
                $label.addClass('error');
            } else {
                $label.removeClass('error');
            }
        });

    // color pickers
    $form
        .find('.select-color').change(function() {
            var choices = [];
            var max_price = 0;
            var $max_option = null;
            var opts = null;

            $(this).parents('.label-input-pair').find('.label').removeClass('error');
            // Empty the #parts
            $('#parts').find('.color_part').remove();

            // Scan all color selects
            $form.find('.select-color').each(function(){
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
                'count':       $form.data('count'),
                'hash':        $(this).data('hash'),
                'price':       $max_option.data('price'),
                'product':     $max_option.data('color'),
                'color_hash':  $max_option.data('hash'),
                'is_color':    true
            };
            $('#parts').append(ich.product_tmpl(opts));

            console.log("=> parts", $('#parts').html());

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

    $form
        .submit(function(e){
            var invalid = false;

            $form.find('select').each(function() {
                // If the checkbox exists, and it's not checked, do not invalidate form
                var hasCheckbox = $(this).parents('.label-input-pair').find('.input-checkbox').size() > 0;
                var isChecked = $(this).parents('.label-input-pair').find('.input-checkbox').prop('checked');

                if ($(this).val() === "invalid") {
                    if (hasCheckbox && !isChecked) {
                        // It has a checkbox, but it's not checked, so
                        // we don't care that the select is not valid
                    } else {
                        $(this).parents('.label-input-pair').find('.label').addClass('error');
                        invalid = true;
                    }
                }
            });
            if (invalid) {
                e.preventDefault();
                $.prompt("Not everything is filled out! Review your order and select a choice for each of the options.");
            }
        });


};


