$(() => {
  const $processesGrid = $("#processes-grid");
  const $loading = $processesGrid.find(".loading");
  const stateFilterLinksSelector = ".order-by__tabs a";
  const typeFilterLinksSelector = "#process-type-filter a";
  $loading.hide();

  $processesGrid.on("click", "#inline-filter-sort a", (event) => {
    handleFilterClick(event, stateFilterLinksSelector);
  });

  $processesGrid.on("click", "#inline-state-filter-sort a", (event) => {
    handleFilterClick(event, typeFilterLinksSelector);
  });

  function handleFilterClick(event, filterLinksSelector) {
    const $processesGridCards = $processesGrid.find(".card-grid");
    const $processesGridSecHeading = $processesGrid.find(".section-heading");
    let $target = $(event.target);

    if (!$target.is("a")) {
      $target = $target.parents("a");
    }

    $(filterLinksSelector).removeClass("is-active");
    $target.addClass("is-active");

    $processesGridCards.hide();
    $loading.show();

    $.ajax({
      type: "GET",
      url: $target.attr("href"),
      success: function (data) {
        const $newCards = $(data).find(".card-grid");
        const $newSecHeading = $(data).find(".section-heading");

        // Update cards content
        $processesGridSecHeading.html($newSecHeading);
        $processesGridCards.html($newCards);
        $processesGridCards.show();
        $loading.hide();

        const currentFilterName = $target.text();
        $target
          .parents(".inline-filters")
          .find("#button-text")
          .text(currentFilterName);
      },
    });
  }
});
