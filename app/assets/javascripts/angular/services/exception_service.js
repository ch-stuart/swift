/*global SwiftApp console window _ */

SwiftApp.service('ExceptionService', ['$http', function($http) {

    function stringify(objs) {
        var stringified = "";

        _.each(objs, function(obj) {
            try {
                stringified += '\n\n' + JSON.stringify(obj);
            } catch (e) {
                if (e.message) {
                    stringified += '\n\n' + e.message;
                } else {
                    stringified += '\n\n' + 'Could not stringify :(';
                }

            }
        });

        return stringified;
    }

    function report(msg, objs) {
        if (objs) {
            msg += stringify(objs);
        }

        // Include UA
        msg += '\n\n' + window.navigator.userAgent;

        // Include URL
        msg += '\n\n' + window.location.href;

        if (window.location.href.indexOf("swift.dev") !== -1 || window.location.href.indexOf("localhost") !== -1) {
            console.error(msg);
        } else {
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
    }

    return { report: report };

}]);

