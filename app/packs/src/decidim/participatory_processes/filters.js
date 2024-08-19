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
    const $processesOrderBy = $processesGrid.find(".processes-grid-order-by");
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
        const $newOrderBy = $(data).find(".processes-grid-order-by");

        // Update cards content
        $processesOrderBy.replaceWith($newOrderBy);
        $processesGridCards.replaceWith($newCards);
        $processesGridCards.show();
        $loading.hide();
        const currentFilterName = $target.text();
        $target
          .parents(".inline-filters")
          .find("#button-text")
          .text(currentFilterName);

        // Reinitialize Foundation (necessary for dropdowns to work again)
        $(document).foundation();

        // Re-bind click event for the help text
        bindHelpTextClick();
      },
    });
  }

  // Function to bind the click event to the help text
  function bindHelpTextClick() {
    const $helpText = $("#help-text");
    const $announcementText = $("#announcement-text");

    if ($helpText.length && $announcementText.length) {
      $helpText.off("click").on("click", () => {
        toggleHelpText();
      });
    }
  }

  function toggleHelpText() {
    const $announcementText = $("#announcement-text");
    const $helpText = $("#help-text");

    const isHidden = $announcementText.hasClass("hidden");

    if (isHidden) {
      showHelpText();
    } else {
      hideHelpText();
    }
  }

  function showHelpText() {
    const $announcementText = $("#announcement-text");
    const $helpText = $("#help-text");

    $announcementText.removeClass("hidden").addClass("visible");
    $helpText.html(`<i class="fa fa-info-circle size-icon-filter" aria-hidden="true"></i> ${$helpText.text().trim()} <i class="fa fa-chevron-up size-icon-filter"></i>`);
    $(document).foundation();
  }

  function hideHelpText() {
    const $announcementText = $("#announcement-text");
    const $helpText = $("#help-text");

    $announcementText.removeClass("visible").addClass("hidden");
    $helpText.html(`<i class="fa fa-info-circle size-icon-filter" aria-hidden="true"></i> ${$helpText.text().trim()} <i class="fa fa-chevron-down size-icon-filter"></i>`);
    $(document).foundation();
  }

  bindHelpTextClick();
});
