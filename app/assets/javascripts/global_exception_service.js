/*global window jQuery */

window.onerror = function(errorMsg, url, lineNumber) {
    var string = JSON.stringify({
        'msg': errorMsg,
        'url': url,
        'lineNumber': lineNumber,
        'userAgent': window.navigator.userAgent,
        'href': window.location.href
    });

    jQuery.post("/exceptions/report", { msg: string });
};
