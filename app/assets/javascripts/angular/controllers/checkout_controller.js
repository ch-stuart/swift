/*jshint browser: true, sub:true */
/*global SwiftApp console alert _ $$ $ Stripe */

SwiftApp.controller('CheckoutCtrl', ['$scope', 'ConfigService', 'CartService', 'PostmasterService', 'PlaceService', 'WaStateTaxService', 'SaleService', 'ExceptionService', function($scope, ConfigService, CartService, PostmasterService, PlaceService, WaStateTaxService, SaleService, ExceptionService) {

    var VALIDATE_ERROR_MSG = "The address you entered appears to be invalid. Please correct it. Contact info@builtbyswift.com if you are unable to resolve this issue.";
    var RATE_ERROR_MSG = "We were unable to retrieve shipping rates. Try again. If this issue continues to occur contact info@builtbyswift.com.";

    var rateParams;

    $scope.cart = CartService.loadFromLocalStorage();
    $scope.domesticServiceLevels = PostmasterService.getDomesticServiceLevels();
    $scope.intlServiceLevels = PostmasterService.getIntlServiceLevels();

    $scope.isShippingReady = false;
    $scope.busyShipping = false;
    $scope.busyBuying = false;
    $scope.countryCodes = PlaceService.countries();
    $scope.states = PlaceService.usStates();

    // Defaults!
    // $scope.line1 = "425 E Sussex AVE";
    // $scope.city = "Missoula";
    // $scope.zip_code = "59801";
    $scope.country = 'US';
    $scope.state = 'MT';
    $scope.shippingServiceLevel = 'GROUND';
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

        rateParams = {
            to_zip: $scope.zipCode,
            to_country: $scope.country,
            weight: CartService.getWeight()
        };

        console.log('postmasterValidateSuccessCallback', data);

        // Is status ever not OK? Assume that error callback
        // is called if status is not OK.
        if (data.status === 'OK') {
            $scope.commercial = rateParams.commercial = !!data.commercial;

            if ($scope.country !== 'US') {
                // This tells postmaster that we
                // only want rates from USPS
                rateParams.carrier = 'usps';
            }
            // If we set the carrier to USPS,
            // we are shipping international
            // (because we only offer USPS when
            // shipping internationally)
            $scope.intl = !!rateParams.carrier;

            if ($scope.state === 'WA') {
                WaStateTaxService
                    .rate({
                        addr: $scope.line1,
                        city: $scope.city,
                        zip: $scope.zipCode
                    })
                    .then(taxSuccessCallback, taxErrorCallback);
            }

            PostmasterService
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
        CartService.setTaxRate(response.data.rate);
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

        // Handle international shipping
        if ($scope.intl) {
            // While below we have to handle errors
            // on a per provider basis... We don't
            // have to do that here because a) there's
            // only on provider, and b) the errorCallback
            // is called in this case.
            var shipping = {
                provider: 'USPS',
                charge: data.charge,
                service: data.service,
                best: true
            };
            $scope.rates.push(shipping);

            // Save this so we can send it to the server
            $scope.shipping = shipping;

            CartService.setShippingCharge(data.charge);
        // Handle domestic shipping
        } else {
            _.each(['fedex', 'usps', 'ups'], function(provider) {
                if (data[provider] && !data[provider].error) {
                    if (data.best === provider) {
                        CartService.setShippingCharge(data[provider].charge);

                        $scope.shipping = {
                            charge: data[provider].charge,
                            provider: provider,
                            service: data[provider].service
                        };
                        console.log('Setting least expensive shipping option as default', $scope.shipping);
                    }
                    $scope.rates.push({
                        best: (data.best === provider),
                        charge: data[provider].charge,
                        provider: provider,
                        service: data[provider].service
                    });
                } else if (data[provider].error) {
                    alert('We are currently unable to provide shipping rates for ' + provider.toUpperCase() + '.');
                    console.warn(data[provider].error.message);
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
                contact: $scope.contact,
                company: $scope.company,
                email: $scope.email,
                description: localStorage.getItem('cart'),
                amount: $scope.cart.price,
                total: $scope.cart.total,
                tax_rate: $scope.cart.taxRate,
                tax_amount: $scope.cart.taxAmount,
                line1: $scope.line1,
                city: $scope.city,
                state: $scope.state,
                zip_code: $scope.zipCode,
                country: $scope.country,
                phone_no: $scope.phoneNo,
                commercial: $scope.commercial,
                weight: CartService.getWeight(),
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
        if (response.data && response.data.error && response.data.error.message) {
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
            CartService.setShippingCharge(null);
            $scope.isShippingReady = $scope.shipping = $scope.rates = $scope.line1 = $scope.city = $scope.zipCode = $scope.phoneNo = null;

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
        CartService.set('pickup', !!$scope.pickup);
    };

    $scope['waStateResidentChanged'] = function() {
        if ($scope.waStateResident) {
            WaStateTaxService
                .rate(ConfigService.get('swiftAddress'))
                .then(taxSuccessCallback, taxErrorCallback);
        } else {
            CartService.setTaxRate(null);
        }
        CartService.set('waStateResident', !!$scope.waStateResident);
    };

    $scope['onCountrySelectChanged'] = function() {
        switch ($scope.country) {
        case 'CA':
            $scope.states = PlaceService.caProvinces();
            $scope.state = 'ON';
            isUnitedStatesOrCanada(true);
            break;
        case 'US':
            $scope.states = PlaceService.usStates();
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
            zip_code: $scope.zipCode,
            country: $scope.country
        };

        $('html, body').animate({
            scrollTop: $("#row-shipping").offset().top
        }, 600);

        PostmasterService
            .validate(validateParams)
            .then(postmasterValidateSuccessCallback, postmasterValidateErrorCallback);
    };

    $scope['onShippingServiceLevelChange'] = function() {
        var localRateParams = rateParams;
        localRateParams.service = $scope.shippingServiceLevel;

        $scope.busyShipping = true;

        PostmasterService
            .rates(localRateParams)
            .then(postmasterRateSuccessCallback, postmasterRateErrorCallback);
    };

    // TODO Update the shipping cost
    // TODO send it to the server when the form is submitted
    // TODO persist in db...
    $scope['onRatesRadioChanged'] = function(provider) {
        console.log('onRatesRadioChanged', provider);

        $scope.shipping = {
            charge: provider.charge,
            provider: provider.provider,
            service: provider.service
        };

        console.log('onRatesRadioChanged', $scope.shipping);

        CartService.setShippingCharge(provider.charge);
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

