(function() {
  var approachingBottomOfPage, content, isLoadingNextPage, lastLoadAt, minTimeBetweenPages, nextPage, viewMore, waitedLongEnoughBetweenPages;

  content = $('#content');

  viewMore = $('#view-more');

  isLoadingNextPage = false;

  lastLoadAt = null;

  minTimeBetweenPages = 2500;

  waitedLongEnoughBetweenPages = function() {
    return lastLoadAt === null || new Date() - lastLoadAt > minTimeBetweenPages;
  };

  approachingBottomOfPage = function() {
    return $(document).scrollTop() + document.documentElement.clientHeight > $("#footer").position().top;
  };

  nextPage = function() {
    var url;
    url = viewMore.find('a').attr('href');
    if (isLoadingNextPage || url == "#" || !url) {
      return;
    }
    viewMore.addClass('loading');
    isLoadingNextPage = true;
    lastLoadAt = new Date();
    return $.ajax({
      url: url,
      method: 'GET',
      dataType: 'script',
      success: function() {
        viewMore.removeClass('loading');
        isLoadingNextPage = false;
        return lastLoadAt = new Date();
      }
    });
  };

  $(window).scroll(function() {
    if (approachingBottomOfPage() && waitedLongEnoughBetweenPages()) {
      return nextPage();
    }
  });

  viewMore.find('a').click(function(e) {
    nextPage();
    return e.preventDefaults();
  });

}).call(this);