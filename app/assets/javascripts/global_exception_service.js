/*global window jQuery */

window.onerror = function(errorMsg, url, lineNumber) {
    var string = JSON.stringify({ 'msg': errorMsg, 'url': url, 'lineNumber': lineNumber });
    var data = { msg: string };

    jQuery.post("/exceptions/report", data);
};
