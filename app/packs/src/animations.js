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
  
  let csvExport = document.getElementsByClassName("exports--format--csv")
  let jsonExport = document.getElementsByClassName("exports--format--json")
  let excelExport = document.getElementsByClassName("exports--format--excel")
  let exportSpan = document.getElementById("export-span")
  let closeExportSpan = document.getElementById("export-span-close")
  
  function exportSpanStyle(exportSpan){
    let dropDown = document.getElementById("export-dropdown")
    dropDown.classList.remove("is-open")
    exportSpan.classList.remove("export-span-hollow")
    exportSpan.classList.add("export-span-show")
  }
  if (closeExportSpan) {
    closeExportSpan.addEventListener("click", () => {
      exportSpan.classList.remove("export-span-show")
      exportSpan.classList.add("export-span-hollow")
    })
  }

  for(let i = 0; i < 2 ; i++){
    csvExport[i] && csvExport[i].addEventListener("click", () => exportSpanStyle(exportSpan))
    jsonExport[i] && jsonExport[i].addEventListener("click", () => exportSpanStyle(exportSpan))
    excelExport[i] && excelExport[i].addEventListener("click", () => exportSpanStyle(exportSpan))
  }

  let showFilters = document.getElementById("filter-btn-br")

  showFilters.addEventListener("click", () => {
    let filtersMenu = document.getElementById("filters__menu")
    let menuStatus = filtersMenu.classList[0]
    
    if(menuStatus == "filters__hidden"){
      filtersMenu.classList.remove("filters__hidden")
      showFilters.innerHTML = `<i class="fa-solid fa-sliders" style="color: #333333;"></i>
      Esconder Filtros`
    } else{
      showFilters.innerHTML = `<i class="fa-solid fa-sliders" style="color: #333333;"></i>
      Mostrar Filtros`
      filtersMenu.classList.add("filters__hidden")
    }
  })
});