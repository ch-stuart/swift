/*global jQuery UA document window localStorage SwiftUtils */
;(function($) {

  window.SwiftUtils = {};

  SwiftUtils.guid = function() {
    return Math.random().toString(16).slice(2);
  };

  var $root = jQuery(document.documentElement);

  $root.removeClass('nojs');

  if (UA.isMobile()) $root.addClass('is-mobile');
  if (UA.isSafari()) $root.addClass('is-safari');
  if (UA.isIOS()) $root.addClass('is-iOS');

  SwiftUtils.notifyOldBrowser = function() {
    $(document.body).prepend(
      ['<p class=browsehappy>',
        'You are using an <strong>outdated</strong> browser.',
        '<a href=//browsehappy.com>Upgrade your browser</a>',
        'to improve your experience.</p>'
      ].join('\n')
    );
  };

  SwiftUtils.notifyNoLocalStorage = function(exception) {
    alert("Could not complete the operation. It appears you're using an old browser, or a browser in privacy mode. Use a modern web browser or turn off privacy mode in order to complete a purchase.");
    console.error(exception);
  };

  if (window.ieVersion && window.ieVersion <= 10) {
    SwiftUtils.notifyOldBrowser();
    $("html").addClass("ie");
  }

  function testLocalStorage() {
    var testString = 'test';
    try {
      localStorage.setItem(testString, testString);
      localStorage.removeItem(testString);
      return true;
    } catch (e) {
      return false;
    }
  }

  var haveLocalStorage = testLocalStorage();

  if (!haveLocalStorage) {
    if (UA.isSafari()) {
      $(document.body).prepend(
        ['<p class=browsehappy>',
          'Hi, It looks like you&rsquo;re browsing in &ldquo;Private Mode&rdquo; on Safari.',
          'If this is the case, you will not be able to complete a purchase.',
          'If you would like to complete a purchase, turn &ldquo;Private Mode&rdquo; off.</p>'
        ].join('\n')
      );
    } else {
      // Ok, here we just warn them that they are using an old browser.
      // Wait until later to alert() when their localStorage fails
      // when used from Application code
      SwiftUtils.notifyOldBrowser();
    }
  }

})(jQuery);
