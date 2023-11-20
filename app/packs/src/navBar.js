export default $(document).ready(function () {
  const itemWidth = $("#process-nav-content ul li").outerWidth(true);

  const ul = $("#process-nav-content ul");

  const isOverflowing = ul[0].scrollWidth > ul[0].clientWidth;

  const isMobile = window.innerWidth <= 820;

  if (isOverflowing) {
    ul.css("justify-content", isOverflowing ? "flex-start" : "space-between");

    if (!isMobile) {
      $("#process-nav-content .scroll-right").show();
      $("#process-nav-content .scroll-left").show();
    }
  }

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
