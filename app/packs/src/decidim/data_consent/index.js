import ConsentManager from "src/decidim/data_consent/consent_manager";

const initDialog = (manager) => {
  if (Object.keys(manager.state).length > 0) {
    return;
  }
  const dialogWrapper = document.querySelector("#dc-dialog-wrapper");
  dialogWrapper.classList.remove("hide");

  const acceptAllButton = dialogWrapper.querySelector("#dc-dialog-accept");
  const rejectAllButton = dialogWrapper.querySelector("#dc-dialog-reject");
  const settingsButton = dialogWrapper.querySelector("#dc-dialog-settings");

  acceptAllButton.addEventListener("click", () => {
    manager.acceptAll();
    dialogWrapper.style.display = "none";
  });

  rejectAllButton.addEventListener("click", () => {
    manager.rejectAll();
    dialogWrapper.style.display = "none";
  });

  settingsButton.addEventListener("click", () => {
    dialogWrapper.style.display = "none";
  });
}

const initModal = (manager) => {
  const categoryElements = manager.modal.querySelectorAll(".category-wrapper");

  categoryElements.forEach((categoryEl) => {
    const categoryButton = categoryEl.querySelector(".dc-title");
    const categoryDescription = categoryEl.querySelector(".dc-description");
    categoryButton.addEventListener("click", () => {
      const hidden = categoryDescription.classList.contains("hide");
      if (hidden) {
        categoryButton.classList.add("open");
        categoryDescription.classList.remove("hide");
      } else {
        categoryButton.classList.remove("open");
        categoryDescription.classList.add("hide");
      }
    })
  })

  const rejectAllButton = manager.modal.querySelector("#dc-modal-reject");
  const saveSettingsButton = manager.modal.querySelector("#dc-modal-save");


  rejectAllButton.addEventListener("click", () => {
    manager.rejectAll();
  })

  saveSettingsButton.addEventListener("click", () => {
    let newState = {};
    manager.categories.forEach((category) => {
      const accepted = manager.modal.querySelector(`input[name='${category}']`).checked;
      if (accepted) {
        newState[category] = true;
      }
    })
    manager.saveSettings(newState);
  })
}

const initDisabledIframes = (manager) => {
  const disabledIframes = document.querySelectorAll(".disabled-iframe")
  if (manager.allAccepted()) {
    disabledIframes.forEach((elem) => {
      const iframe = document.createElement("iframe")
      iframe.setAttribute("src", elem.getAttribute("src"));
      iframe.className = elem.classList.toString();
      iframe.setAttribute("allowfullscreen", elem.getAttribute("allowfullscreen"));
      iframe.setAttribute("frameborder", elem.getAttribute("frameborder"));
      elem.parentElement.appendChild(iframe);
      elem.remove();
    })
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const modal = document.querySelector("#dc-modal");
  if (!modal) {
    return;
  }

  const categories = [...modal.querySelectorAll(".category-wrapper")].map((el) => el.dataset.id)
  const manager = new ConsentManager({
    modal: modal,
    categories: categories,
    cookieName: window.Decidim.config.get("consent_cookie_name"),
    warningElement: document.querySelector(".dataconsent-warning")
  });

  initDisabledIframes(manager);
  initModal(manager, categories);
  initDialog(manager);
});
