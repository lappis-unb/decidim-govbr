document.addEventListener("DOMContentLoaded", function () {
  const showRulesCardButton = document.getElementById("showRulesButton");
  const rulesCard = document.getElementById("info_card");
  const helpButtonText = document.getElementById("helpButtonIdText").value;

  if (showRulesCardButton && rulesCard) {
    showRulesCardButton.addEventListener("click", toggleRulesCard);
  }

  function toggleRulesCard() {
    const isCardHidden = rulesCard.classList.contains("vote_rules_card_hidden");

    if (isCardHidden) {
      showRulesCard();
    } else {
      hideRulesCard();
    }
  }

  function showRulesCard() {
    rulesCard.classList.remove("vote_rules_card_hidden");
    rulesCard.classList.add("vote_rules_card_visible");
    rulesCard.offsetHeight;
    rulesCard.classList.add("show__rules__card");
    showRulesCardButton.innerHTML = `<i class="fa-solid fa-info-circle fa-lg" style="color: var(--blue-warm-vivid-80);"></i>${helpButtonText}<i class="fa-solid fa-chevron-up"></i>`;
  }

  function hideRulesCard() {
    rulesCard.classList.remove("vote_rules_card_visible");
    rulesCard.classList.remove("show__rules__card");
    rulesCard.classList.add("vote_rules_card_hidden");
    showRulesCardButton.innerHTML = `<i class="fa-solid fa-info-circle fa-lg" style="color: var(--blue-warm-vivid-80);"></i>${helpButtonText}<i class="fa-solid fa-chevron-down"></i>`;
  }
});
