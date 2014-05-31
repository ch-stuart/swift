/*global window jQuery */

window.onerror = function(errorMsg, url, lineNumber) {
    // Don't bother if there isn't a errorMsg
    if (!errorMsg) return;

    var string = JSON.stringify({
        'msg': errorMsg,
        'url': url,
        'lineNumber': lineNumber,
        'userAgent': window.navigator.userAgent,
        'href': window.location.href
    });

    jQuery.post("/exceptions/report", { msg: string });
};
