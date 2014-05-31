/*global SwiftApp console window */

SwiftApp.service('ExceptionService', ['$http', function($http) {

    function stringify(objs) {
        var stringified = "";

        _.each(objs, function(obj) {
            try {
                stringified += ' :: ' + JSON.stringify(obj);
            } catch (e) {
                if (e.message) {
                    stringified += ' :: ' + e.message;
                } else {
                    stringified += ' :: ' + 'Could not stringify :(';
                }

            }
        });

        return stringified;
    }

    function report(msg, objs) {
        if (objs) {
            msg = msg + stringify(objs);
        }

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

