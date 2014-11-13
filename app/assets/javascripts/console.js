(function(w) {
  // In case of stray console statements.
  if (typeof w.console === 'undefined') {
    var noop = function() {};
    w.console = {
      log: noop,
      info: noop,
      debug: noop,
      warn: noop,
      error: noop
    };
  }
})(window);
