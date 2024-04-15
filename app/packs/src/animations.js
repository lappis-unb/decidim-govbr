document.addEventListener("DOMContentLoaded", function () {
  var avatarButton = document.getElementById("avatar-dropdown-trigger");
  var userMenuLinks = document.querySelectorAll(".br-list-dropdown a");
  var userMenu = document.getElementById("avatar-menu");

  if (avatarButton) {
    avatarButton.addEventListener("click", function () {
      userMenuLinks.forEach(function (link, i) {
        if (link.classList.contains("show-br-list-dropdown")) {
          link.classList.remove("show-br-list-dropdown");
        } else {
          setTimeout(function () {
            link.classList.add("show-br-list-dropdown");
          }, 100 * i);
        }
      });
      if (userMenu.classList.contains("br-list-dropdown-in-view")) {
        userMenu.classList.remove("br-list-dropdown-in-view");
      } else {
        setTimeout(function () {
          userMenu.classList.add("br-list-dropdown-in-view");
        }, 100 * userMenuLinks.length);
      }
    });
  }
  var menuLateral = document.getElementById("lateral-menu");

  var observer = new IntersectionObserver(
    function (entries, observer) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add("show-menu-links");
        } else {
          entry.target.classList.remove("show-menu-links");
        }
      });
    },
    { threshold: 0.5 }
  );

  observer.observe(menuLateral);

  let csvExport = document.getElementsByClassName("exports--format--csv");
  let jsonExport = document.getElementsByClassName("exports--format--json");
  let excelExport = document.getElementsByClassName("exports--format--excel");
  let exportSpan = document.getElementById("export-span");
  let exportCommentsSpan = document.getElementById("export-comments-span");
  let closeExportSpan = document.getElementById("export-span-close");

  function exportSpanStyle(exportSpan) {
    let dropDown = document.getElementById("export-dropdown");
    dropDown.classList.remove("is-open");
    exportSpan.classList.remove("export-span-hollow");
    exportSpan.classList.add("export-span-show");
  }

  function exportCommentsSpanStyle(exportCommentsSpanStyle) {
    let dropDown = document.getElementById("export-comments-dropdown");
    dropDown.classList.remove("is-open");
    exportSpan.classList.remove("export-span-hollow");
    exportSpan.classList.add("export-span-show");
  }

  if (closeExportSpan) {
    closeExportSpan.addEventListener("click", () => {
      exportSpan.classList.remove("export-span-show");
      exportSpan.classList.add("export-span-hollow");
    });
  }

  for (let i = 0; i < 2; i++) {
    csvExport[i] &&
      csvExport[i].addEventListener("click", () => exportSpanStyle(exportSpan));
    jsonExport[i] &&
      jsonExport[i].addEventListener("click", () =>
        exportSpanStyle(exportSpan)
      );
    excelExport[i] &&
      excelExport[i].addEventListener("click", () =>
        exportSpanStyle(exportSpan)
      );
    csvExport[i] &&
      csvExport[i].addEventListener("click", () =>
        exportCommentsSpanStyle(exportCommentsSpan)
      );
    jsonExport[i] &&
      jsonExport[i].addEventListener("click", () =>
        exportCommentsSpanStyle(exportCommentsSpan)
      );
    excelExport[i] &&
      excelExport[i].addEventListener("click", () =>
        exportCommentsSpanStyle(exportCommentsSpan)
      );
  }

  const showFiltersButton = document.getElementById("filter-btn-br");
  const filtersMenu = document.getElementById("filters__menu");
  const filtersTriangle = document.getElementById("filters__triangle");

  showFiltersButton.addEventListener("click", toggleFilters);

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
    filtersTriangle.classList.remove("filters__hidden");
    filtersMenu.offsetHeight;
    filtersTriangle.offsetHeight;
    filtersMenu.classList.add("show__filters__menu");
    filtersTriangle.classList.add("show__filters__menu");
    showFiltersButton.innerHTML = `<i class="fa-solid fa-sliders fa-lg" style="color: #333333;"></i> Esconder Filtros`;
  }

  function hideFilters() {
    filtersMenu.classList.remove("filters__visible");
    filtersMenu.classList.remove("show__filters__menu");
    filtersTriangle.classList.add("filters__hidden");
    filtersTriangle.classList.remove("show__filters__menu");
    showFiltersButton.innerHTML = `<i class="fa-solid fa-sliders fa-lg" style="color: #333333;"></i> Mostrar Filtros`;

    setTimeout(() => {
      filtersMenu.classList.add("filters__hidden");
    }, 500);
  }
});
