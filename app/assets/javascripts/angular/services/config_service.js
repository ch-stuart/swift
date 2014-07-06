/*global window SwiftApp */

SwiftApp.service('ConfigService', function() {

    var config = {
        swiftAddress: {
            addr: '1415 NW 49th Street',
            city: 'Seattle',
            zip: '98107'
        },
        WS: window.__iswsu__
    };

    return {
        get: function(key) {
            return config[key];
        }
    };

});
