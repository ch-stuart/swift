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

    window.onerror = function myErrorHandler(errorMsg, url, lineNumber) {
        report(JSON.stringify({
            'msg': errorMsg,
            'url': url,
            'lineNumber': lineNumber
        }));
    };

    return { report: report };

}]);
