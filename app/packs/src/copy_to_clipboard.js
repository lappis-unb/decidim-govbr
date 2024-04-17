document.addEventListener("DOMContentLoaded", function () {
  var clipboardButton = document.getElementById("copy-proposal-link-button");
  if (clipboardButton) {
    clipboardButton.addEventListener("click", function () {
      var urlShareLink = document.getElementById("urlShareLink");
      if (urlShareLink) {
        urlShareLink.select();
        navigator.clipboard.writeText(urlShareLink.value).then(function () {
          clipboardButton.innerHTML = "Copiado! ✓";
        });
      }
    });
  }
});
