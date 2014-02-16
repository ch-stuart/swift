/*global jQuery console */
function checkout() {
    $('#checkout-form').submit(function(event) {

        var $form = $(this);
        $form.find('button').prop('disabled', true);

        Stripe.createToken($form, function stripeResponseHandler(status, response) {
            console.log('stripe response handler');

            if (response.error) {
                console.log('error', response.error.message);
                $form.find('.payment-errors').text(response.error.message);
                $form.find('button').prop('disabled', false);
            } else {
                console.log('good response');
                var token = response.id;
                $form.append($('<input type="hidden" name="stripeToken">').val(token));
                $form.get(0).submit();
            }
        });
        return false;
    });
    $('#j').val(localStorage.getItem('cart'));
}
