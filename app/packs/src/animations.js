document.addEventListener("DOMContentLoaded", function () {
  var observer = new IntersectionObserver(
    function (entries, observer) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting && entry.intersectionRatio >= 0.5) {
          entry.target.classList.add("in-view");
        } else if (entry.intersectionRatio < 0.5) {
          entry.target.classList.remove("in-view");
        }
      });
    },
    { threshold: [0.1, 0.75] }
  );

  var cardAnimations = document.querySelectorAll(".card__animation");

  cardAnimations.forEach(function (cardAnimation) {
    observer.observe(cardAnimation);
  });

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
});
