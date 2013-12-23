casper.test.begin('Can purchase product', function suite(test) {
    casper.start("http://swift.dev/", function() {
        this.click('.nav-list--group-item-link:first-child')
    })

    casper.then(function() {
        var isProductPage = this.evaluate(function() {
            return location.href.indexOf('product') !== -1
        })
        this.test.assert(isProductPage, 'got to product page')
    })

    casper.then(function() {
        this.click('#submit_order')
    })

    casper.then(function() {
        var isOrderPage = this.evaluate(function() {
            return location.href.indexOf('order') !== -1
        })
        this.test.assert(isOrderPage, 'got to order page')
    })

    casper.then(function() {
        this.click('#submit_order')
    })

    casper.then(function() {
        this.test.assertTitle('Cart', 'Got to Mals')
        this.test.assertTextExists('Prod1 Title', 'product is in cart')
    })

    casper.then(function() {
        this.click('a:first-child')
    })

    casper.then(function() {
        var title = 'Swift Industries | handmade bicycle panniers and accessories';
        this.test.assertTitle(title, 'Got back to builtbyswift.com')
    })

    casper.run(function() {
        test.done()
    })
});