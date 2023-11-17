export default $(document).ready(function () {
  const itemWidth = $("#process-nav-content ul li").outerWidth(true);

  var isMobile = window.innerWidth <= 820;

  function scrollToSelected() {
    const selectedLi = $("#process-nav-content ul li.active");
    if (selectedLi.length) {
      const scrollPosition = selectedLi.position().left - itemWidth;
      $("#process-nav-content ul").animate(
        {
          scrollLeft: scrollPosition,
        },
        "slow"
      );
    }
  }

  scrollToSelected();

  if (isMobile) {
    $(".scroll-button").addClass("hidden");
  }
  $(".scroll-right").click(function () {
    $("#process-nav-content ul").animate(
      {
        scrollLeft: `+=${itemWidth * 3}`,
      },
      400
    );
  });

  $(".scroll-left").click(function () {
    $("#process-nav-content ul").animate(
      {
        scrollLeft: `-=${itemWidth * 3}`,
      },
      400
    );
  });
});
