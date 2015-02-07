SwiftApp.service('GiftCertService', ['$http', '$q', function($http, $q) {

    return {
        get: function(code) {
            var deferred = $q.defer();

            console.log('GiftCertService.get', code);

            if (!code) {
                deferred.reject({ errorMsg: 'That code could not be found.' });
            } else if (!/^[A-Za-z0-9_-]+$/.test(code) || code.length !== 8) {
                deferred.reject({ errorMsg: 'That is not a valid code.' });
            } else {
                code = encodeURIComponent(code);
                $http
                    .get('/gift_certificates/show?format=json&guid=' + code)
                    .success(function(response) {
                        deferred.resolve({
                          remainingAmount: parseFloat(response.remaining_amount)
                        });
                    })
                    .error(function(data, status) {
                        deferred.reject({ status: status });
                    });
            }

            return deferred.promise;
        }
    };

}]);
