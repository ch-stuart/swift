/*jshint browser: true, sub:true */
/*global SwiftApp console alert _ $$ $ Stripe */

SwiftApp.controller('CheckoutCtrl', [
    '$scope',
    'ConfigService',
    'CartService',
    'PostmasterService',
    'PlaceService',
    'WaStateTaxService',
    'SaleService',
    'ExceptionService',
    'PackagingService',
    function(
        $scope,
        ConfigService,
        CartService,
        PostmasterService,
        PlaceService,
        WaStateTaxService,
        SaleService,
        ExceptionService,
        PackagingService) {

    var package_count = 1;
    var rates_response_count = 0;

    var RATE_ERROR_MSG = "We were unable to retrieve shipping rates. Verify that you have entered your country and zip code correctly. If this issue continues to occur contact info@builtbyswift.com.";

    var SHIPPING_PROVIDERS = ['fedex', 'usps', 'ups'];

    $scope.cart = CartService.loadFromLocalStorage();
    $scope.WS = ConfigService.get('WS');

    // Don't show checkout if cart is empty
    if (!$scope.cart.products.length) {
        window.location = '/cart';
    }

    $scope.domesticServiceLevels = PostmasterService.getDomesticServiceLevels();
    $scope.intlServiceLevels = PostmasterService.getIntlServiceLevels();
    $scope.isShippingDomestic = true;

    $scope.isShippingReady = false;
    $scope.busyShipping = false;
    $scope.busyBuying = false;
    $scope.countryCodes = PlaceService.countries();
    $scope.states = PlaceService.usStates();

    $scope.rateParams = {};

    // Defaults!
    $scope.country = 'US';
    $scope.state = 'MT';

    $scope.shippingServiceLevel = 'GROUND';
    $scope.countryIsUSCA = true;

    $scope.$on('cart:prices:update', function(e, price, total, taxAmount, taxRate, shippingCharge) {
        $scope.cart.price          = price;
        $scope.cart.total          = total;
        $scope.cart.taxAmount      = taxAmount;
        $scope.cart.taxRate        = taxRate;
        $scope.cart.shippingCharge = shippingCharge;
    });

    function postmasterValidateSuccessCallback(response) {
        var data = response.data;

        // Calculate how many boxes we need to
        // ship the package
        var packages = PackagingService.fit();
        package_count = packages.length;

        // Set rate params
        $scope.rateParams = {
            to_zip:     $scope.zipCode,
            to_country: $scope.country,
            weight:     packages[0].weight,
            width:      packages[0].width,
            height:     packages[0].height,
            length:     packages[0].length,
            // packaging:  packages[0].packaging,
            service:    $scope.shippingServiceLevel,
            carrier:    $scope.shippingCarrier
        };

        // Don't include these guys if shipping via LETTER
        // if ($scope.rateParams.packaging === 'LETTER') {
        //     delete $scope.rateParams.width;
        //     delete $scope.rateParams.height;
        //     delete $scope.rateParams.length;
        // }

        console.log('postmasterValidateSuccessCallback', data);

        // Is status ever not OK? Assume that error callback
        // is called if status is not OK.
        if (data.status === 'OK') {
            $scope.commercial = $scope.rateParams.commercial = !!data.commercial;

            if ($scope.state === 'WA' && !$scope.WS) {
                WaStateTaxService
                    .rate({
                        addr: $scope.line1,
                        city: $scope.city,
                        zip: $scope.zipCode
                    })
                    .then(taxSuccessCallback, taxErrorCallback);
            }

            _.each(packages, function() {
                PostmasterService
                    .rates($scope.rateParams)
                    .then(postmasterRateSuccessCallback, postmasterRateErrorCallback);
            });
        } else {
            ExceptionService.report('CheckoutCtrl#postmasterValidateSuccessCallback: data.status not "OK"', [data]);
        }
    }

    function postmasterValidateErrorCallback(response) {
        $scope.busyShipping = false;
        $scope.customerNeedsToVerifyAddress = true;

        // Commenting this out. TMI
        // ExceptionService.report('CheckoutCtrl#postmasterValidateErrorCallback: Address validation failed.', [response]);

        // Postmaster's address validation is flaky. Doesn't seem
        // to work at all for international customers.
        // Because of this, we allow the customer to bypass the
        // check, so long as they tick a box saying they looked
        // at it and it's good
        if ($scope.customerVerifiedAddress) {
            // Commenting this out. TMI
            // ExceptionService.report('CheckoutCtrl#postmasterValidateErrorCallback: Customer verified address is AOK.', [response]);
            // Fake out the validate success callback
            // response obj
            postmasterValidateSuccessCallback({
                data: {
                    status: 'OK',
                    commercial: false,
                    validated: false,
                    validateResponse: response
                }
            });
        }
    }

    function taxSuccessCallback(response) {
        console.log('taxSuccessCallback', response);
        CartService.setTaxRate(response.data.rate);
    }

    function taxErrorCallback(response) {
        console.log('taxErrorCallback', response);
    }

    var rateResponses = [];
    function postmasterRateSuccessCallback(response) {
        console.log('postmasterRateSuccessCallback: response', response);
        // Cannot proceed until we have received all of the callbacks
        rates_response_count++;

        rateResponses.push(response);

        console.log('postmasterRateSuccessCallback: Received callback ' + rates_response_count + ' of ' + package_count);
        if (rates_response_count < package_count) {
            return;
        }

        var combinedResponse = {};

        // If we only got one provider back...
        if (!$scope.isShippingDomestic || 'service' in response.data) {
            combinedResponse['usps'] = {};
            combinedResponse['usps'].charge = 0;

            _.each(rateResponses, function(response) {
                combinedResponse['usps'].charge += response.data.charge;
            });
        } else {
            // If any of the providers failed to respond to
            // any of the rates requests remove them from the
            // SHIPPING_PROVIDERS array
            _.each(rateResponses, function(response) {
                if (!response.data.hasOwnProperty('ups')) {
                    SHIPPING_PROVIDERS = _.without(SHIPPING_PROVIDERS, 'ups');
                }
                if (!response.data.hasOwnProperty('fedex')) {
                    SHIPPING_PROVIDERS = _.without(SHIPPING_PROVIDERS, 'fedex');
                }
                if (!response.data.hasOwnProperty('usps')) {
                    SHIPPING_PROVIDERS = _.without(SHIPPING_PROVIDERS, 'usps');
                }
            });

            _.each(SHIPPING_PROVIDERS, function(provider) {
                combinedResponse[provider] = {};
                combinedResponse[provider].charge = 0;

                _.each(rateResponses, function(response) {
                    combinedResponse[provider].charge += response.data[provider].charge;
                });
                console.log('charge for', provider, 'should be', combinedResponse[provider].charge);
            });
        }

        $scope.rates = [];
        $scope.shipping = {};
        $scope.busyShipping = false;
        $scope.isShippingReady = true;

        // Use the most recent response data
        // for some things
        var data = response.data;

        // Handle international shipping
        if (!$scope.isShippingDomestic) {
            // While below we have to handle errors
            // on a per provider basis... We don't
            // have to do that here because a) there's
            // only on provider, and b) the errorCallback
            // is called in this case.
            var shipping = {
                provider: 'USPS',
                charge: combinedResponse['usps'].charge,
                service: data.service,
                best: true
            };
            $scope.shippingServiceLevel = data.service;
            $scope.rates.push(shipping);

            // Save this so we can send it to the server
            $scope.shipping = shipping;

            CartService.setShippingCharge(combinedResponse['usps'].charge);
        // Handle domestic shipping
        } else {
            _.each(SHIPPING_PROVIDERS, function(provider) {
                if (data[provider] && !data[provider].error) {

                    if (data.best === provider) {
                        CartService.setShippingCharge(data[provider].charge);

                        // Set best as the default on the scope
                        $scope.shipping = {
                            charge: data[provider].charge,
                            provider: provider,
                            service: data[provider].service
                        };
                        console.log('Setting least expensive shipping option as default', $scope.shipping);
                    }
                    // Push all rates into an array
                    $scope.rates.push({
                        best: (data.best === provider),
                        charge: combinedResponse[provider].charge,
                        provider: provider,
                        service: data[provider].service
                    });
                } else if (data[provider] && data[provider].error) {
                    var msg = 'We are currently unable to provide shipping rates for ' + provider.toUpperCase() + '.';
                    ExceptionService.report(msg);
                    alert(msg);
                    console.warn(data[provider].error.message);
                }
            });
        }
    }

    function postmasterRateErrorCallback(response) {
        $scope.busyShipping = false;
        console.warn('PostmasterService.rates => Error:', response);
        ExceptionService.report('CheckoutCtrl#postmasterRateErrorCallback ' + JSON.stringify(response));
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
                // FIXME this should actually get the weight
                // for one package?
                weight: PackagingService.getShippingWeight(),
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
            ExceptionService.report('CheckoutCtrl#saleChargeErrorCallback ' + JSON.stringify(response));
            alert(response.data.error.message);
        }
    }

    function saleCreateSuccessCallback(response) {
        console.log('saleCreateSuccessCallback', response);
        $scope.busyBuying = false;

        window.location = "/orders/" + response.data.guid;
    }

    function saleCreateErrorCallback(response) {
        if (response.data && response.data.error) {
            var errors = [];
            _.each(response.data.error, function(value, key) {
                _.each(value, function(element) {
                    errors.push(key + ' ' + element + '.');
                });
            });
            alert(errors.join('\n'));
        } else {
            ExceptionService.report('CheckoutCtrl#saleCreateErrorCallback ' + JSON.stringify(response));
            alert('A server error occurred.');
        }
        $scope.busyBuying = false;
    }

    // Reset this data, because we're going to
    // validate and get rates again (assuming the
    // customer has already hit the button once)
    function resetRateResponsesAndCounters() {
        rateResponses.splice(0, rateResponses.length);
        rates_response_count = 0;
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
            $scope.isShippingReady = $scope.shipping = $scope.rates = null;
            $scope.line1 = $scope.city = $scope.zipCode = $scope.phoneNo = '';

            // Set form state to pristine
            $scope.shippingForm.$setPristine(true);

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

        $scope.isShippingDomestic = $scope.country == 'US' ? true : false;

        switch ($scope.country) {
        case 'US':
            // Set default domestic shipping service level
            $scope.shippingServiceLevel = 'GROUND';
            // Display list of US States
            $scope.states = PlaceService.usStates();
            // Default to MT
            $scope.state = 'MT';
            // Show the <select>
            $scope.countryIsUSCA = true;
            // Don't choose one carrier (use UPS, USPS and Fedex)
            $scope.shippingCarrier = null;
            break;
        case 'CA':
            // Set default INTL shipping service level
            $scope.shippingServiceLevel = 'INTL_PRIORITY';
            // Show list of CA provinces
            $scope.states = PlaceService.caProvinces();
            // Default to ON(tario)
            $scope.state = 'ON';
            // Show the <select> for choosing province
            $scope.countryIsUSCA = true;
            // Only use USPS for INTL shipping
            $scope.shippingCarrier = 'usps';
            break;
        default:
            // Set default INTL shipping service level
            $scope.shippingServiceLevel = 'INTL_PRIORITY';
            // Don't show dropdown
            $scope.countryIsUSCA = false;
            // Only use USPS for INTL shipping
            $scope.shippingCarrier = 'usps';
            // Unset the state field
            $scope.state = '';
        }
    };

    $scope['onCalculateShippingCostBtnClicked'] = function(isValid) {
        var $scrollToElem;

        if (!isValid) {
            return alert('The information you entered is incomplete. Fill in all fields and try again.');
        }

        resetRateResponsesAndCounters();

        $scope.busyShipping = true;

        $scope.validateParams = {
            line1: $scope.line1,
            city: $scope.city,
            state: $scope.state,
            zip_code: $scope.zipCode,
            country: $scope.country
        };

        if ($(window).width() > 767) {
            $scrollToElem = $("#row-shipping");
        } else {
            $scrollToElem = $("#rates-submit");
        }
        $('html, body').animate({
            scrollTop: $scrollToElem.offset().top
        }, 600);

        PostmasterService
            .validate($scope.validateParams)
            .then(postmasterValidateSuccessCallback, postmasterValidateErrorCallback);
    };

    $scope['onShippingServiceLevelChange'] = function() {
        resetRateResponsesAndCounters();

        console.log('CheckoutCtrl#onShippingServiceLevelChange', $scope.shippingServiceLevel);
        $scope.busyShipping = true;

        PostmasterService
            .validate($scope.validateParams)
            .then(postmasterValidateSuccessCallback, postmasterValidateErrorCallback);
    };

    $scope['onRatesRadioChanged'] = function(provider) {
        console.log('CheckoutCtrl#onRatesRadioChanged', provider);

        $scope.shipping = {
            charge: provider.charge,
            provider: provider.provider,
            service: provider.service
        };

        CartService.setShippingCharge(provider.charge);
    };

    $scope['onBuyItButtonClicked'] = function(isValid) {
        console.log('isValid', isValid);
        if (!isValid) {
            return alert('The information you entered is incomplete. Fill in all fields and try again.');
        }

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

