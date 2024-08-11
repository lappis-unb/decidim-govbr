$(() => {
    const $processesGrid = $("#processes-grid");
    const $loading = $processesGrid.find(".loading");
    const filterLinksSelector = ".order-by__tabs a";
  
    $loading.hide();
  
    $processesGrid.on("click", filterLinksSelector, (event) => {
      const $processesGridCards = $processesGrid.find(".card-grid .column");
      let $target = $(event.target);
  
      if (!$target.is("a")) {
        $target = $target.parents("a");
      }
  
      $(filterLinksSelector).removeClass("is-active");
      $target.addClass("is-active");
  
      $processesGridCards.hide();
      $loading.show();
  
      $.ajax({
        type: "GET",
        url: $target.attr("href"),
        success: function(data) {
          const $newCards = $(data).find(".card-grid .column");
  
          // Atualizar o conteúdo dos cards
          $processesGridCards.html($newCards);
          $processesGridCards.show();
          $loading.hide();
  
          // Atualizar o texto do botão com o filtro atual
          const currentFilterName = $target.text(); // Obter o texto do filtro selecionado
          $("#button-text").text(currentFilterName); // Atualizar o botão
        }
      });
    });
  });