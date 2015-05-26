/*global jQuery $ window */
jQuery.fn.tabs = function(params) {

  var loc = window.location,
      defaults = {
        'tabs': '.tab',
        'cards': '.card',
        'index': '0'
      };

  if (loc.hash.indexOf('tab')) {
    defaults.index = loc.hash.replace('#tab', '');
  }

  params = $.extend(defaults, params);

  return this.each(function() {
    var $tabWrapper,
        setActive;

    $tabWrapper = $(this);

    setActive = function(idx) {
      $tabWrapper
        .find(params.tabs)
        .removeClass('active')
        .eq(idx)
        .addClass('active');

      $tabWrapper
        .find(params.cards)
        .removeClass('active')
        .eq(idx)
        .addClass('active');

      if (params.routing) {
        loc.hash = '#tab' + idx;
      }
    };

    setActive(params.index);

    $tabWrapper.on('click', params.tabs, function(e) {
      e.preventDefault();
      setActive($(this).index());
    });

  });
};
