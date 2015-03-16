;(function(w) {
  var $srcSetImgs = $('.js-srcset-img'),
      src,
      srcSet,
      newUrl;

  // Safari says it supports src set (which it probably does via 1x, 2x)
  // so for now can't do this
  // if ('srcset' in document.createElement('img')) {
  //   return; // console.debug('Browser supports srcset');
  // }

  if ($srcSetImgs.size() === 0) {
    return;
  }

  $srcSetImgs.each(function(idx, srcSetImg) {
    var $srcSetImg = $(srcSetImg);

    src = $srcSetImg.attr('src');
    srcSet = $srcSetImg.attr('srcset');

    _.each(window.srcset.parse(srcSet), function(srcSetOption) {
      if ($(window).width() > srcSetOption.width) {
        newUrl = srcSetOption.url;
      }
    });

    if (newUrl) {
      $srcSetImg.attr('src', newUrl);
    }
  });

})(window);
