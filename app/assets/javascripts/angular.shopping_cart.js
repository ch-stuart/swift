/*global window console */
;(function() {

    // Feature detect + local reference
    var storage,
        fail,
        uid;

    try {
        uid = new Date();
        (storage = window.localStorage).setItem(uid, uid);
        fail = storage.getItem(uid) != uid;
        storage.removeItem(uid);

        if (fail) {
            storage = null;
        }
    } catch(e) {
        console.warn('window.localStorage not available');
    }

    // function Cart() {
    //
    // }

})();
