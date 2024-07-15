document.addEventListener("DOMContentLoaded", function () {
  var clipboardButtons = document.getElementsByClassName("button copy-link-button"); 
  for (var i = 0; i < clipboardButtons.length; i++) {
    clipboardButtons[i].addEventListener("click", function () {
      var urlShareLink = document.getElementById("urlShareLink"); 
      if (urlShareLink) {
        urlShareLink.select();
        navigator.clipboard.writeText(urlShareLink.value).then(function () {
          this.innerHTML = "Copiado! ✓";
        }.bind(this)); 
      }
    });
  }
});