document.addEventListener("DOMContentLoaded", function () {
  const showRulesCardButton = document.getElementById("showRulesButton");

  showRulesCardButton.addEventListener("click", toggleRulesCard);

  function toggleRulesCard() {
    const rulesCard = document.getElementById("voting_rules");
    const isCardHidden = rulesCard.classList.contains("vote_rules_card_hidden");

    if (isCardHidden) {
      showRulesCard();
    } else {
      hideRulesCard();
    }
  }

  function showRulesCard() {
    const rulesCard = document.getElementById("voting_rules");
    rulesCard.classList.remove("vote_rules_card_hidden");
    rulesCard.classList.add("vote_rules_card_visible");
    rulesCard.offsetHeight;
    rulesCard.classList.add("show__rules__card");
    showRulesCardButton.innerHTML = `<i class="fa-solid fa-info-circle fa-lg" style="color: var(--blue-warm-vivid-80);"></i> Esconder Regras`;
  }

  function hideRulesCard() {
    const rulesCard = document.getElementById("voting_rules");
    rulesCard.classList.remove("vote_rules_card_visible");
    rulesCard.classList.remove("show__rules__card");
    rulesCard.classList.add("vote_rules_card_hidden");
    showRulesCardButton.innerHTML = `<i class="fa-solid fa-info-circle fa-lg" style="color: var(--blue-warm-vivid-80);"></i> Conheça os critérios para a seleção de proposta`;
  }
});
