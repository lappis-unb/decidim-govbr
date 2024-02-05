const copyLinkToClipboard = async (event) => {
  if (event) {
    event.preventDefault();
  }
  // TODO: Consertar mensagem de alerta que aparece nos navegadores
  // try {
  //   await new Promise(resolve => setTimeout(resolve, 50));
  //   await navigator.clipboard.writeText(window.location.href);
  // } catch (err) {
  //   console.error("Failed to copy: ", err);
  // }
};

document.addEventListener("DOMContentLoaded", () => {
  const linkClipboards = document.querySelectorAll(".link-clipboard");
  if (linkClipboards) {
    linkClipboards.forEach((linkClipboard) => {
      linkClipboard.addEventListener("click", copyLinkToClipboard);
    });
  }

  const clipboard_icon = document.getElementById("clipboard-icon")
    if (clipboard_icon) {
      clipboard_icon.addEventListener("click", function (event) {
        document.getElementById("clipboard-button").click();

        event.stopPropagation();
      });
    }
});

export { copyLinkToClipboard };
