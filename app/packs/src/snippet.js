(() => {
  window.addEventListener("DOMContentLoaded", (e) => {
    ImportScriptFile();
    CreateDOMObjects();

    // Evento para primeira letra maiuscula
    capitalizarOnBlur("proposal_title");
    capitalizarOnBlur("proposal_body");

    definirUrlLogOut();

    showCreateProfileLink();
    removeSecondProductionLogin();

    removeBPMenu();

    updateContentMarginTop();
    convertIconsToHttps();
    window.addEventListener("resize", updateContentMarginTop);

    doEverything();
  });
})();

const removeBPMenu = () => {
  if (window.location.pathname.includes("/processes/brasilparticipativo")) {
    const processHeader = document.querySelector(".process-header");
    if (processHeader) {
      processHeader.remove();
    }
    const processNav = document.querySelector(".process-nav");
    if (processNav) {
      processNav.remove();
    }
  }
};

// --------------------------- vlibras ---------------------------
var CreateDOMObjects = () => {
  const DOM = `
    <div vw class="enabled">
    <div vw-access-button class="active"></div>
    <div vw-plugin-wrapper>
      <div class="vw-plugin-top-wrapper"></div>
    </div>
    </div>
  `;
  document.body.insertAdjacentHTML("beforeend", DOM);

  var elAcessButton = document.querySelector("div[vw-access-button]");
  var elPLuginWrapper = document.querySelector("div[vw-plugin-wrapper]");

  elAcessButton.addEventListener(
    "click",
    function () {
      if (!elPLuginWrapper.classList.contains("active")) {
        elPLuginWrapper.classList.add("active");
        elAcessButton.classList.remove("active");

        //close
        var elSettingClose = document.querySelector(".vpw-settings-btn-close");

        $("div[vw]").on("click", ".vpw-settings-btn-close", function (event) {
          elPLuginWrapper.classList.remove("active");
          elAcessButton.classList.add("active");
        });
      }
    },
    false
  );
};

var ImportScriptFile = () => {
  let script = document.createElement("script");
  script.src = "https://vlibras.gov.br/app/vlibras-plugin.js";
  script.onload = () => {
    new window.VLibras.Widget("https://vlibras.gov.br/app");
  };
  document.body.appendChild(script);
};

// --------------------------- capitalizar ---------------------------

function capitalizarOnBlur(elementId) {
  let element = document.getElementById(elementId);
  if (element != undefined && element != null) {
    element.onblur = function () {
      capitalizar(element);
    };
  }
}
function capitalizar(input) {
  if (input.value.length > 0) {
    input.value = input.value.charAt(0).toUpperCase() + input.value.slice(1);
  }
}

// --------------------------- logout ---------------------------

function definirUrlLogOut() {
  var logOutUrl;
  var hostname = window.location.hostname;

  if (hostname.endsWith(".presidencia.gov.br")) {
    logOutUrl =
      "https://sso.acesso.gov.br/logout?post_logout_redirect_uri=https://" +
      hostname +
      "/users/sign_out";
  } else {
    logOutUrl =
      "https://sso.staging.acesso.gov.br/logout?post_logout_redirect_uri=https://" +
      hostname +
      "/users/sign_out";
  }

  var link = $(".sign-out-link");

  if (link && link.length > 0) {
    link.removeAttr("data-method");
    link.attr("href", "#");
    link.on("click", function () {
      window.location.href = logOutUrl;
    });
  }
}

// --------------------------- create profile link---------------------------

function showCreateProfileLink() {
  const loginButton = document.querySelector(
    ".sign-in-button .br-sign-in span"
  );
  if (!loginButton) {
    const link = document.getElementById("create-profile-container");
    if (link) link.remove();
  }
}

// --------------------------- remove second login ---------------------------

function removeSecondProductionLogin() {
  if (
    window.location.href ===
    "https://brasilparticipativo.presidencia.gov.br/users/sign_in"
  ) {
    const cardContent = document.querySelector(".card__content");
    const registerSeparator = document.querySelector(".register__separator");
    const loginText = document.querySelector(
      ".columns.large-8.large-centered.text-center.page-title p"
    );
    const shadowRow = document.querySelector(
      ".columns.large-6.medium-centered"
    );

    if (shadowRow) shadowRow.remove();
    if (cardContent) cardContent.remove();
    if (loginText) loginText.remove();
    if (registerSeparator) registerSeparator.remove();
  }
}

// --------------------------- content margin top ---------------------------
function updateContentMarginTop() {
  const header = document.querySelector("#br-header");
  const menu = document.querySelector("#process-nav-content");
  const content = document.querySelector("#content");
  if (header) {
    if (content) {
      content.style.marginTop = header.offsetHeight - 2 + "px";
    }
    if (menu && content) {
      menu.style.top = header.offsetHeight - 2 + "px";
    }
  }
}

// --------------- doEverything ----------------
function doEverything() {
  const navbarUl = document.querySelector(".process-nav ul");
  if (navbarUl) {
    if (window.location.href.includes("/processes/ENGD")) {
      var allElements = document.querySelectorAll("*:not(script):not(style)");
      var respond_comment_button = document.querySelectorAll(
        ".comment__reply.muted-link"
      );
      respond_comment_button.forEach((btn) => btn.remove());

      respond_comment_button.forEach((btn) => btn.remove());

      var opinionToggleButton = document.querySelector(".opinion-toggle");
      if (opinionToggleButton) {
        opinionToggleButton.remove();
      }

      var indiceButton = document.querySelector(".see-index-container");
      if (indiceButton) {
        indiceButton.remove();
      }
      const elements = document.querySelectorAll(
        ".callout.alert.callout--full"
      );

      const homeSections = document.querySelectorAll(
        ".section.row.collapse.highlighted_proposals"
      );
      homeSections.forEach((section) => {
        section.remove();
      });

      const spaceMenu = navbarUl.querySelectorAll("li");

      if (spaceMenu.length) {
        spaceMenu.forEach((liElement) => {
          liElement.remove();
        });
      }

      if (window.location.href.includes("/processes/ENGD/f/77")) {
        const participatoryList = document.querySelector(
          ".participatory-text-list"
        );

        if (participatoryList) {
          const participatoryItems = participatoryList.querySelectorAll(
            ".participatory-text-item"
          );

          participatoryItems.forEach((item) => {
            const textItems = item.querySelector("a");
            const firstTextItem = textItems.firstElementChild;

            if (
              firstTextItem &&
              (firstTextItem.textContent.startsWith("CAPÍTULO") ||
                firstTextItem.textContent.startsWith("Seção"))
            ) {
              const itemActionsDiv = item.querySelector(".item-actions");
              itemActionsDiv.remove();

              const newDiv = document.createElement("div");
              newDiv.innerHTML = textItems.innerHTML;
              newDiv.style = textItems.style;
              textItems.parentNode.replaceChild(newDiv, textItems);

              item.style.pointerEvents = "none";
            }
          });
        }
      }
    }
  }

  const urlProgram = window.location.href;
  const oldLink = document.querySelector(".ql-editor-display a");
  if (oldLink && urlProgram.includes(`/processes/programas/f/1/proposals/43`)) {
    var newLink = document.createElement("a");
    newLink.id = "id-new-link";
    newLink.href = "/link?external_url=https://www.gov.br/mda/pt-br";
    newLink.textContent = "https://www.gov.br/mda/pt-br";
    oldLink.parentNode.replaceChild(newLink, oldLink);
  }
  const loginButton = document.querySelector(
    "a.button--govbr span.button--social__text"
  );
  if (loginButton) {
    loginButton.innerHTML = "Entrar com <strong>gov.br</strong>";
  }
}

function convertIconsToHttps() {
  const icons = document.querySelectorAll("link");
  if (icons) {
    icons.forEach((icon) => {
      if (icon && icon.src && icon.src.includes("http://")) {
        icon.src = icon.src.replace("http://", "https://");
      }
    });
  }
}
