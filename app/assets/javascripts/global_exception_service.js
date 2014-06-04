/*global window jQuery */

;(function(window, jQuery) {
    var msgBlockList = [
        'Script error.',
        'ReferenceError: Can\'t find variable: cafe',
        'ReferenceError: Can\'t find variable: dataKeys'
    ];

    var scriptUrlBlockList = [
        'http://assets.pinterest.com/js/pinit.js'
    ];

    window.onerror = function(msg, url, lineNumber) {
        var string = '';

        // Don't bother if there isn't a msg
        if (!msg) return;

        for (var m = msgBlockList.length - 1; m >= 0; m--) {
            if (msg === msgBlockList[m]) return;
        }

        for (var s = scriptUrlBlockList.length - 1; s >= 0; s--) {
            if (url === scriptUrlBlockList[s]) return;
        }

        string += '== Error\n';
        string += msg + '\n\n';

        string += '== Script URL\n';
        string += url + '\n\n';

        string += '== lineNumber\n';
        string += lineNumber + '\n\n';

        string += '== userAgent\n';
        string += window.navigator.userAgent + '\n\n';

        string += '== URL\n';
        string += window.location.href + '\n\n';

        jQuery.post("/exceptions/report", { msg: string });
    };
})(window, jQuery);
