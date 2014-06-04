/*global window jQuery */

;(function(window, jQuery) {
    var msgBlockList = [
        'Script error.',
        // ReferenceError: Can\'t find ...
        'variable: cafe',
        'variable: dataKeys',
        'variable: contentSizeInPopover',
        'variable: pageDidLoad',
        'variable: pixelmagsDidLoad'
    ];

    var scriptUrlBlockList = [
        'assets.pinterest.com/js/pinit.js'
    ];

    window.onerror = function(msg, url, lineNumber) {
        var string = '';

        // Don't bother if there isn't a msg
        if (!msg) return;

        for (var m = msgBlockList.length - 1; m >= 0; m--) {
            if (msg.indexOf(msgBlockList[m]) !== -1) return;
        }

        for (var s = scriptUrlBlockList.length - 1; s >= 0; s--) {
            if (url.indexOf(scriptUrlBlockList[s]) !== -1) return;
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
