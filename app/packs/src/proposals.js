document.addEventListener("DOMContentLoaded", function () {
  var errorMessage = document.getElementById("new-proposal-error-alert");
  var lastErrorMessage = "";

  var currentErrorMessage = errorMessage.value;

  if (currentErrorMessage !== "" && currentErrorMessage !== lastErrorMessage) {
    alert(currentErrorMessage);
    lastErrorMessage = currentErrorMessage;
  }
});
