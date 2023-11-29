const getNavBar = () => {
  document.addEventListener("DOMContentLoaded", function () {
    const processNavContent = $("#process-nav-content");

    if (processNavContent.length > 0) {
      const ul = processNavContent.find("ul");

      if (ul.length > 0) {
        const itemWidth = ul.find("li").outerWidth(true);
        const isOverflowing = ul[0].scrollWidth > ul[0].clientWidth;
        const isMobile = window.innerWidth <= 820;

        if (isOverflowing) {
          ul.css("justify-content", isOverflowing ? "space-between" : "center");

          if (!isMobile) {
            processNavContent.find(".scroll-right").show();
            processNavContent.find(".scroll-left").show();
          }
        }

        function scrollToSelected() {
          const selectedLi = ul.find("li.active");
          if (selectedLi.length) {
            const scrollPosition = selectedLi.position().left - itemWidth;
            ul.animate(
              {
                scrollLeft: scrollPosition,
              },
              "slow"
            );
          }
        }

        scrollToSelected();

        processNavContent.find(".scroll-right").click(function () {
          ul.animate(
            {
              scrollLeft: `+=${itemWidth * 3}`,
            },
            400
          );
        });

        processNavContent.find(".scroll-left").click(function () {
          ul.animate(
            {
              scrollLeft: `-=${itemWidth * 3}`,
            },
            400
          );
        });
      }
    }
  });
};

export { getNavBar };
