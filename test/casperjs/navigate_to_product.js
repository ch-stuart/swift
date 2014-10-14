var noop = function(){};

casper.test.begin('Can navigate purchase flow', function suite(test) {

    casper.start("http://localhost:3000/products/79", function() {
        this.evaluate(function() {
            localStorage.removeItem('cart');
        });
        console.log(this.getCurrentUrl());
        this.click('#js-go_to_order');
    });

    casper.then(function() {
        console.log(this.getCurrentUrl());
        this.click('#js-submit_order');
    });

    casper.then(function() {
        console.log(this.getCurrentUrl());
        this.waitForSelector('#js-check-out', function() {
            this.click('#js-check-out');
        });
    });

    casper.then(function() {
        console.log(this.getCurrentUrl());
        this.test.assert(!!this.getCurrentUrl().match(/checkout/), 'got to checkout page');
    });

    casper.run(function() {
        test.done();
    });

});
