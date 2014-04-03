SwiftApp.service('ConfigService', function() {

    var config = {
        swiftAddress: {
            addr: '1415 NW 49th Street',
            city: 'Seattle',
            zip: '98107'
        }
    }

    return {
        get: function(key) {
            return config[key];
        }
    };

});
