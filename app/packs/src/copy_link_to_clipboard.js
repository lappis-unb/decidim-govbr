const copyLinkToClipboard = async (event) => {
  if (event) {
    event.preventDefault();
  }
  try {
    await new Promise(resolve => setTimeout(resolve, 50));
    await navigator.clipboard.writeText(window.location.href);
  } catch (err) {
    console.error("Failed to copy: ", err);
  }
};

document.addEventListener("DOMContentLoaded", () => {
  const linkClipboards = document.querySelectorAll(".link-clipboard");
  if (linkClipboards) {
    linkClipboards.forEach((linkClipboard) => {
      linkClipboard.addEventListener("click", copyLinkToClipboard);
    });
  }
});

export { copyLinkToClipboard };
