SwiftApp.service('CouponService', ['$http', '$q', function($http, $q) {

    return {
        get: function(code) {
            var defer = $q.defer();

            console.log('CouponService.get', code);

            if (!code) {
                $q.reject({ data: 'No code supplied' });
            }
            if (!/^[A-Za-z0-9_-]+$/.test(code)) {
                $q.reject({ data: 'Code not a valid format' });
            }

            code = encodeURIComponent(code);

            defer = $http.get('/coupons/' + code + '/valid.json');
            return defer;
        }
    };

}]);
