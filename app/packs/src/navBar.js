export default $(document).ready(function () {
  var scrollInterval;

  var isMobile = window.innerWidth <= 820;

  if (isMobile) {
    $(".scroll-button").addClass("hidden");
  }

  $(".scroll-right").mousedown(function () {
    scrollInterval = setInterval(function () {
      $("#process-nav-content ul").animate(
        {
          scrollLeft: "+=20",
        },
        50
      );
    }, 50);
  });
  $(".scroll-left").mousedown(function () {
    scrollInterval = setInterval(function () {
      $("#process-nav-content ul").animate(
        {
          scrollLeft: "-=20",
        },
        50
      );
    }, 50);
  });
  $(".scroll-right, .scroll-left").mouseup(function () {
    clearInterval(scrollInterval);
  });
  $(".scroll-right, .scroll-left").mouseleave(function () {
    clearInterval(scrollInterval);
  });
});
