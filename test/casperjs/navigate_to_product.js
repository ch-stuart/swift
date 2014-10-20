var noop = function(){};

casper.test.begin('Can navigate purchase flow', function suite(test) {

    casper.on('remote.message', function(msg) {
        casper.echo(msg);
    });

    casper.start("http://localhost:3000/products/79", function() {
        this.evaluate(function() {
            localStorage.removeItem('cart');
        });
        console.log(this.getCurrentUrl());
        this.click('#js-goto-order');
    });

    casper.then(function() {
        console.log(this.getCurrentUrl());
        this.click('#js-submit-order');
    });

    casper.then(function() {
        console.log(this.getCurrentUrl());
        this.waitForSelector('#js-check-out', function() {
            this.click('#js-check-out');
        });
    });

    casper.then(function() {
        console.log(this.getCurrentUrl());
        this.test.assert(!!this.getCurrentUrl().match(/checkout/), 'should be at checkout page');
    });

    casper.run(function() {
        test.done();
    });

});
