
// static - main
$(document).ready(function(){       

  $("ul.main_tab li.main_tab_item").click(function(e) {
    /* Add the slider movement */
    // what tab was pressed
    var whatTab = $(this).index();
    var whatWidth = $(this).width();
    // Work out how far the slider needs to go
    var howFar = whatWidth * whatTab + 16 * whatTab;
    var tab_id = $(this).attr("id");

    
    if (tab_id == "inside_tab") {
      $("#inside_img").fadeIn(1000);
      $("#outside_img").hide();
      $("#owner_img").hide();
      $(".slider").css({
        left: howFar + "px",
        width: whatWidth
      });
    } else if (tab_id == "outside_tab") {
      $("#inside_img").hide();
      $("#outside_img").fadeIn(1000);
      $("#owner_img").hide();
      $(".slider").css({
        left: howFar + "px",
        width: whatWidth
      });
    } else if (tab_id == "owner_tab") {
      $("#inside_img").hide();
      $("#outside_img").hide();
      $("#owner_img").fadeIn(1000);
      $(".slider").css({
        left: howFar + "px",
        width: whatWidth
      });
    }
  });
  
  // counter
  var a = 0;
  $(window).scroll(function() {
    var oTop = $('#counter').offset().top - window.innerHeight;
    if (a == 0 && $(window).scrollTop() > oTop) {
      $('.counter-value').each(function() {
        var $this = $(this),
          countTo = $this.attr('data-count');
        $({
          countNum: $this.text()
        }).animate({
            countNum: countTo
          },
          {
            duration: 2000,
            easing: 'swing',
            step: function() {
              $this.text(numberWithCommas(Math.floor(this.countNum)));
            },
            complete: function() {
              $this.text(numberWithCommas(this.countNum));
              //alert('finished');
            }
          });
      });
      a = 1;
    }
  });

  function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
 
});
 