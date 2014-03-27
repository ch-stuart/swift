/*jshint browser: true, sub:true */
/*global SwiftApp console alert _ $$ $ Stripe */

SwiftApp.controller('CheckoutCtrl', ['$scope', 'Config', 'Cart', 'Postmaster', 'Place', 'WaStateTaxService', 'SaleService', function($scope, Config, Cart, Postmaster, Place, WaStateTaxService, SaleService) {

    var VALIDATE_ERROR_MSG = "The address you entered appears to be invalid. Please correct it. Contact info@builtbyswift.com if you are unable to resolve this issue.";
    var RATE_ERROR_MSG = "We were unable to retrieve shipping rates. Try again. If this issue continues to occur contact info@builtbyswift.com.";

    $scope.cart = Cart.loadFromLocalStorage();
    $scope.isShippingReady = false;
    $scope.busyShipping = false;
    $scope.busyBuying = false;
    $scope.countryCodes = Place.countries();
    $scope.states = Place.usStates();

    $scope.pickup = $scope.cart.pickup;
    $scope.waStateResident = $scope.cart.waStateResident;

    // Defaults!
    // $scope.line1 = "425 E Sussex AVE";
    // $scope.city = "Missoula";
    // $scope.zip_code = "59801";
    $scope.country = 'US';
    $scope.state = 'MT';
    isUnitedStatesOrCanada(true);

    function isUnitedStatesOrCanada(bool) {
        if (bool) {
            $scope.countryIsUSCA = true;
        } else {
            $scope.countryIsUSCA = false;
            $scope.state = '';
        }
    }

    $scope.$on('cart:prices:update', function(e, price, total, taxAmount, taxRate, shippingCharge) {
        $scope.cart.price          = price;
        $scope.cart.total          = total;
        $scope.cart.taxAmount      = taxAmount;
        $scope.cart.taxRate        = taxRate;
        $scope.cart.shippingCharge = shippingCharge;
    });

    function postmasterValidateSuccessCallback(response) {
        var data = response.data;
        var rateParams = {
            to_zip: $scope.zip_code,
            to_country: $scope.country,
            weight: Cart.getWeight()
        };

        console.log('postmasterValidateSuccessCallback', data);

        // Is status ever not OK? Assume that error callback
        // is called if status is not OK.
        if (data.status === 'OK') {
            rateParams.commercial = !!data.commercial;

            if ($scope.country !== 'US') {
                rateParams.carrier = 'usps';
            }
            $scope.intl = !!rateParams.carrier;

            if ($scope.state === 'WA') {
                WaStateTaxService
                    .rate({
                        addr: $scope.line1,
                        city: $scope.city,
                        zip: $scope.zip_code
                    })
                    .then(taxSuccessCallback, taxErrorCallback);
            }

            Postmaster
                .rates(rateParams)
                .then(postmasterRateSuccessCallback, postmasterRateErrorCallback);
        }
    }

    function postmasterValidateErrorCallback(response) {
        $scope.busyShipping = false;
        console.warn('PostmasterService.validate => Error:', response);
        alert(VALIDATE_ERROR_MSG);
    }

    function taxSuccessCallback(response) {
        console.log('taxSuccessCallback', response);
        Cart.setTaxRate(response.data.rate);
    }

    function taxErrorCallback(response) {
        console.log('taxErrorCallback', response);
    }

    function postmasterRateSuccessCallback(response) {
        console.log('rateSuccessCallback', response);
        $scope.rates = [];
        $scope.shipping = {};
        $scope.busyShipping = false;
        $scope.isShippingReady = true;

        var data = response.data;

        if ($scope.intl) {
            var shipping = {
                provider: 'USPS',
                charge: data.charge,
                service: data.service
            };
            $scope.rates.push(shipping);

            // Save this so we can send it to the server
            $scope.shipping = shipping;

            Cart.setShippingCharge(data.charge);
        } else {
            _.each(['fedex', 'usps', 'ups'], function(provider) {
                // And save it here too...
                $scope.shipping = {
                    charge: data[data.best].charge,
                    provider: data.best,
                    service: data[data.best].service
                };

                Cart.setShippingCharge(data[data.best].charge);

                // However, for now we want to show the options.
                // We may or may not allow the customer to choose.
                // I would guess that we will.
                if (data[provider]) {
                    $scope.rates.push({
                        best: (data.best === provider),
                        charge: data[provider].charge,
                        provider: provider,
                        service: data[provider].service
                    });
                }
            });
        }
    }

    function postmasterRateErrorCallback(response) {
        $scope.busyShipping = false;
        console.warn('PostmasterService.rates => Error:', response);
        alert(RATE_ERROR_MSG);
    }

    function saleChargeSuccessCallback(response) {
        console.log('saleChargeSuccessCallback', response);

        if (!$scope.shipping) {
            $scope.shipping = {
                provider: null,
                charge: null,
                service: null
            };
        }

        SaleService
            .create({
                email: $scope.email,
                description: localStorage.getItem('cart'),
                amount: $scope.cart.price,
                total: $scope.cart.total,
                tax_rate: $scope.cart.taxRate,
                tax_amount: $scope.cart.taxAmount,
                line1: $scope.line1,
                city: $scope.city,
                state: $scope.state,
                zip_code: $scope.zip_code,
                country: $scope.country,
                pickup: $scope.pickup,
                shipping_provider: $scope.shipping.provider,
                shipping_charge: $scope.shipping.charge,
                shipping_service: $scope.shipping.service,
                stripe_id: response.data.id,
                send_me_marketing_emails: $scope.send_me_marketing_emails
            })
            .then(saleCreateSuccessCallback, saleCreateErrorCallback);
    }

    function saleChargeErrorCallback(response) {
        console.log('saleChargeErrorCallback', response);
        $scope.busyBuying = false;
        if (response.data.error.message) {
            alert(response.data.error.message);
        }
    }

    function saleCreateSuccessCallback(response) {
        console.log('saleCreateSuccessCallback', response);
        $scope.busyBuying = false;

        window.location = "/orders/" + response.data.guid;
    }

    function saleCreateErrorCallback(response) {
        var errors = [];
        _.each(response.data.error, function(value, key) {
            _.each(value, function(element) {
                errors.push(key + ' ' + element + '.');
            });
        });
        alert(errors.join('\n'));
        $scope.busyBuying = false;
    }

    $scope['onPickupChanged'] = function() {
        // Customer is picking up
        if ($scope.pickup) {
            setTimeout(function () {
                $('html, body').animate({
                    scrollTop: $("#row-wa-tax-check").offset().top
                }, 1200);
            }, 100);
            // Unset shipping data
            Cart.setShippingCharge(null);
            $scope.shipping = $scope.rates = $scope.line1 = $scope.city = $scope.zip_code = null;

        // Customer is shipping
        } else {
            // They might be a WA state resident, however, we
            // no longer use the checkbox to figure it out...
            // Instead we'll use their shipping address
            $scope.waStateResident = null;
            // This turns off the WA taxes, since we'll grab
            // them again using the customer's shipping
            // address, assuming they live in WA.
            $scope['waStateResidentChanged']();
        }
        Cart.set('pickup', !!$scope.pickup);
    };

    $scope['waStateResidentChanged'] = function() {
        if ($scope.waStateResident) {
            WaStateTaxService
                .rate(Config.get('swiftAddress'))
                .then(taxSuccessCallback, taxErrorCallback);
        } else {
            Cart.setTaxRate(null);
        }
        Cart.set('waStateResident', !!$scope.waStateResident);
    };

    $scope['onCountrySelectChanged'] = function() {
        switch ($scope.country) {
        case 'CA':
            $scope.states = Place.caProvinces();
            $scope.state = 'ON';
            isUnitedStatesOrCanada(true);
            break;
        case 'US':
            $scope.states = Place.usStates();
            $scope.state = 'MT';
            isUnitedStatesOrCanada(true);
            break;
        default:
            isUnitedStatesOrCanada(false);
        }
    };

    $scope['onCalculateShippingCostBtnClicked'] = function() {
        $scope.busyShipping = true;

        var validateParams = {
            line1: $scope.line1,
            city: $scope.city,
            state: $scope.state,
            zip_code: $scope.zip_code,
            country: $scope.country
        };

        $('html, body').animate({
            scrollTop: $("#row-shipping").offset().top
        }, 600);

        Postmaster
            .validate(validateParams)
            .then(postmasterValidateSuccessCallback, postmasterValidateErrorCallback);
    };

    $scope['onBuyItButtonClicked'] = function() {
        $scope.busyBuying = true;

        Stripe.createToken($$('row-payment'), function stripeResponseHandler(status, response) {
            if (response.error) {
                $scope.busyBuying = false;
                // FIXED the busy indicator is not going
                // away for some reason, unless you force
                // it to re-evaluate.
                $scope.$digest();
                alert(response.error.message);
            } else {
                var token = response.id;

                SaleService
                    .charge({
                        total: $scope.cart.total,
                        stripeToken: token,
                        email: $scope.email
                    })
                    .then(saleChargeSuccessCallback, saleChargeErrorCallback);
            }
        });
    };

}]);

