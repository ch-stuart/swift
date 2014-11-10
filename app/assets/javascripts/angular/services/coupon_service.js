SwiftApp.service('CouponService', ['$http', '$q', function($http, $q) {

    return {
        get: function(code) {
            var deferred = $q.defer();

            console.log('CouponService.get', code);

            if (!code) {
                console.log('ha');
                deferred.reject({ errorMsg: 'That code could not be found.' });
            } else if (!/^[A-Za-z0-9_-]+$/.test(code)) {
                console.log('stupid');
                deferred.reject({ errorMsg: 'That code is not a valid format.' });
            } else {
                code = encodeURIComponent(code);
                $http
                    .get('/coupons/' + code + '/valid.json')
                    .success(function(response) {
                        deferred.resolve(response.coupon);
                    })
                    .error(function(data, status) {
                        deferred.reject({ status: status });
                    });
            }

            return deferred.promise;
        }
    };

}]);
