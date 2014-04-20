/*global SwiftApp console window */

SwiftApp.service('ExceptionService', ['$http', function($http) {

    function report(msg) {
        $http
            .post('/exceptions/report', { msg: msg })
            .then(
                function() {
                    console.log('Exception reported', msg);
                },
                function() {
                    console.error('Exception *not* reported', msg);
                }
            );
    }

    return { report: report };

}]);
