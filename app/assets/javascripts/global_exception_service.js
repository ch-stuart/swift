/*global window jQuery console */

;(function(window, jQuery) {
    var msgBlockList = [
        'Script error.',
        // ReferenceError: Can\'t find ...
        // Assuming these are browser extensions behaving badly
        'variable: cafe',
        'variable: dataKeys',
        'variable: contentSizeInPopover',
        'variable: pageDidLoad',
        'variable: pixelmagsDidLoad',
        'inappbrowser',
        'variable: sCapGloRef',
        'variable: admwl',
        'variable: gcdemodata'
    ];

    var scriptUrlBlockList = [
        'assets.pinterest.com/js/pinit.js',
        'ssl.google-analytics.com/ga.js',
        'newrelic.com',
        'blockpage.cgi',
        'widgets.pinterest.com'
    ];

    window.onerror = function(msg, url, lineNumber) {
        var string = '';

        // Don't bother if there isn't a msg
        if (!msg) return;

        for (var m = msgBlockList.length - 1; m >= 0; m--) {
            if (msg.indexOf(msgBlockList[m]) !== -1) return;
        }

        if (url) {
            for (var s = scriptUrlBlockList.length - 1; s >= 0; s--) {
                if (url.indexOf(scriptUrlBlockList[s]) !== -1) return;
            }
        }

        string += '== Error\n';
        string += msg + '\n\n';

        if (url) {
            string += '== Script URL\n';
            string += url + '\n\n';
        }

        if (lineNumber) {
            string += '== lineNumber\n';
            string += lineNumber + '\n\n';
        }

        string += '== userAgent\n';
        string += window.navigator.userAgent + '\n\n';

        string += '== URL\n';
        string += window.location.href + '\n\n';


        if (window.location.href.indexOf("swift.dev") !== -1) {
            console.error(string);
        } else {
            jQuery.post("/exceptions/report", { msg: string });
        }

    };
})(window, jQuery);
