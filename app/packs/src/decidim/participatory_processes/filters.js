$(() => {
  const $processesGrid = $("#processes-grid");
  const $loading = $processesGrid.find(".loading");
  const stateFilterLinksSelector = ".order-by__tabs a";
  const typeFilterLinksSelector = "#process-type-filter a";
  const scopeFilterSelector = "#filters__menu input[type='radio'], #filters__menu input[type='checkbox']";
  $loading.hide();

  $processesGrid.on("click", "#inline-filter-sort a", (event) => {
    handleFilterClick(event, stateFilterLinksSelector);
  });

  $processesGrid.on("click", "#inline-state-filter-sort a", (event) => {
    handleFilterClick(event, typeFilterLinksSelector);
  });

  $processesGrid.on("change", scopeFilterSelector, (event) => {
    handleFilterClick(event, scopeFilterSelector);
  });

  function handleFilterClick(event, filterLinksSelector) {
    const $processesGridCards = $processesGrid.find(".card-grid");
    const $processesOrderBy = $processesGrid.find(".processes-grid-order-by");
    const $processesScopeFilters = $processesGrid.find(".proposals-filters");
    let $target = $(event.target);
    console.log($target);

    
    if (!$target.is("a")) {
      $target = $target.parents("a");
    }

    $(filterLinksSelector).removeClass("is-active");
    $target.addClass("is-active");

    $processesGridCards.hide();
    $loading.show();

    const full_url = window.location.search;
    let host = "";
    if (full_url) host = full_url.split("?")[0];
    let params = new URLSearchParams(host);

    const stateFilterLink = $processesGrid.find("#inline-filter-sort a.is-active");
    const typeFilterLink = $processesGrid.find("#inline-filter-sort a.is-active");

    if (stateFilterLink.length) {
      params.set('state', stateFilterLink.attr('data-state'));
    }

    if (typeFilterLink.length) {
      params.set('type', typeFilterLink.attr('data-type'));
    }

    $(scopeFilterSelector).each(function() {
      if ($(this).is(':checked')) {
        params.append($(this).attr('name'), $(this).val());
      }
    });

    const href = $target.attr("href") || $target.prevObject[0].formAction;
    const url = href + (href.includes('?') ? '&' : '?') + params.toString();


    $.ajax({
      type: "GET",
      url: url,
      success: function (data) {
        const $newCards = $(data).find(".card-grid");
        const $newOrderBy = $(data).find(".processes-grid-order-by");
        const $newScopeFilters = $(data).find(".proposals-filters");

        // Update cards content
        $processesOrderBy.replaceWith($newOrderBy);
        $processesGridCards.replaceWith($newCards);
        $processesScopeFilters.replaceWith($newScopeFilters);
        $processesGridCards.show();
        $loading.hide();

        // Update the button text
        const currentFilterName = $target.text();
        $target
          .parents(".inline-filters")
          .find("#button-text")
          .text(currentFilterName);

        // Reinitialize Foundation (necessary for dropdowns to work again)
        $(document).foundation();

        // Re-bind click event for the help text
        bindHelpTextClick();

        // Re-bind click event for scopes filters
        bindScopesButtonClick();
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

  function bindScopesButtonClick() {
    const showFiltersButton = document.getElementById("filter-btn-br");
    const filtersMenu = document.getElementById("filters__menu__container");

    if (showFiltersButton) {
      showFiltersButton.addEventListener("click", toggleFilters);
    }

    function toggleFilters() {
      const isMenuHidden = filtersMenu.classList.contains("filters__hidden");

      if (isMenuHidden) {
        showFilters();
      } else {
        hideFilters();
      }
    }

    function showFilters() {
      filtersMenu.classList.remove("filters__hidden");
      filtersMenu.classList.add("filters__visible");
      filtersMenu.offsetHeight;
      filtersMenu.classList.add("show__filters__menu");
      showFiltersButton.innerHTML = `<i class="fa-solid fa-sliders fa-lg" style="color: #333333;"></i> Esconder Filtros`;
    }

    function hideFilters() {
      filtersMenu.classList.remove("filters__visible");
      filtersMenu.classList.remove("show__filters__menu");
      showFiltersButton.innerHTML = `<i class="fa-solid fa-sliders fa-lg" style="color: #333333;"></i> Mostrar Filtros`;

      setTimeout(() => {
        filtersMenu.classList.add("filters__hidden");
      }, 500);
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