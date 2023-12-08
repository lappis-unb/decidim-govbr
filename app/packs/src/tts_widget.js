function readAloud(e, t, texto) {
  const s =
    (/iPad|iPhone|iPod/.test(navigator.userAgent) &&
      ((e.src = n + "sound/silence.mp3"),
      e.play(),
      "undefined" != typeof speechSynthesis &&
        speechSynthesis.speak(new SpeechSynthesisUtterance(" "))),
    document.createElement("script"));

  s.onload = function () {
    if (e) {
      readAloudInit(e, t, null, texto);
    }
  };

  s.src = window.location.origin + "/" + "readaloud.js";
  document.head.appendChild(s);
}

function ttsQuestion() {
  readAloud(
    document.getElementById("ra-audio"),
    document.getElementById("ra-player"),
    "Olá, eu sou o Voz para Todos! Sou uma ferramenta que lê para você o conteúdo desta página web e esse é o meu tutorial de uso. Para me utilizar corretamente, basta clicar no botão azul e um alto falante, ele é responsável por me ligar e começar a minha leitura do início até o fim da página. Caso deseje ler apenas um trecho específico, selecione ele com seu mouse e, com o texto selecionado, aperte novamente no meu botão. Enquanto eu leio a página, também marco o trecho que está sendo lido e destaco a palavra atual, para o seu melhor acompanhamento! E pronto! Você agora está pronto para me utilizar em todas as páginas deste site. "
  );
}

function renderButton() {
  const vwContainer = document.createElement("div");
  vwContainer.setAttribute("vw", "");
  vwContainer.classList.add("enabled");

  const vwAccessButton = document.createElement("div");
  vwAccessButton.setAttribute("vw-access-button", "");
  vwAccessButton.classList.add("active");

  const vwPluginWrapper = document.createElement("div");
  vwPluginWrapper.setAttribute("vw-plugin-wrapper", "");

  const vwPluginTopWrapper = document.createElement("div");
  vwPluginTopWrapper.classList.add("vw-plugin-top-wrapper");

  // Adiciona os elementos ao corpo (body)
  vwPluginWrapper.appendChild(vwPluginTopWrapper);
  vwContainer.appendChild(vwAccessButton);
  vwContainer.appendChild(vwPluginWrapper);

  document.body.appendChild(vwContainer);

  const ttsQuestionButton = document.createElement("button");
  ttsQuestionButton.setAttribute("id", "tts-question");
  ttsQuestionButton.onclick = ttsQuestion();
  ttsQuestionButton.appendChild(document.createTextNode("?"));

  // Adiciona o botão ao corpo (body)
  document.body.appendChild(ttsQuestionButton);

  // Cria o elemento de áudio
  const audioElement = document.createElement("audio");
  audioElement.setAttribute("id", "ra-audio");
  audioElement.setAttribute("data-lang", "pt-BR");
  audioElement.setAttribute("data-voice", "free");
  audioElement.setAttribute("data-key", "dda900319d5b19d3f7ec703ca1338196");

  // Adiciona o elemento de áudio ao corpo (body)
  document.body.appendChild(audioElement);

  const question = document.getElementById("tts-question");
  const ttsContainer = document.createElement("div");
  const ttsButton = document.createElement("div");
  ttsContainer.id = "tts-container";
  ttsButton.setAttribute("ttsOn", "false");
  ttsButton.id = "tts-button";
  const ttsButtonIcon = document.createElement("img");
  ttsButtonIcon.id = "tts-button-icon";
  ttsButtonIcon.src = require("../images/play-btn-tts.svg");
  // debugger
  ttsButton.append(ttsButtonIcon);
  ttsContainer.append(ttsButton);
  ttsContainer.append(question);
  document.body.appendChild(ttsContainer);
}

function handleTTS() {
  var texto;
  const ttsButton = document.getElementById("tts-button");
  if (ttsButton && ttsButton.getAttribute("ttson") == "true") {
    const ttsPlayer = document.getElementById("ra-player");
    const ttsContainer = document.getElementById("tts-container");
    ttsContainer.removeChild(ttsPlayer);
    ttsButton.setAttribute("ttson", "false");
    speechSynthesis.cancel(leitor);

    if (checkRead != true) {
      let paragrafoAnterior =
        document.getElementsByClassName("read-aloud")[readIndex - 1];
      paragrafoAnterior.style.borderRadius = "";
      paragrafoAnterior.style.padding = "";
      paragrafoAnterior.style.background = "";
      paragrafoAnterior.innerHTML = anterior.innerHTML;
    }

    readIndex = 0;
    checkRead = false;
    ajuda = false;
  } else {
    const raPlayer = document.createElement("div");
    const raButton = document.createElement("div");
    const playIcon = document.createElement("img");
    const ttsContainer = document.getElementById("tts-container");

    raPlayer.id = "ra-player";
    raPlayer.setAttribute(
      "data-skin",
      "https://assets.readaloudwidget.com/embed/skins/default"
    );
    raButton.classList.add("ra-button");
    raButton.addEventListener("click", function () {
      var selection = window.getSelection();
      var selectedText = selection.toString().trim();
      texto = selectedText;
      console.log("Texto selecionado:", texto);
      readAloud(
        document.getElementById("ra-audio"),
        document.getElementById("ra-player"),
        texto
      );
    });
    playIcon.src =
      "https://assets.readaloudwidget.com/embed/skins/default/play-icon.png";
    raButton.append(playIcon);
    raButton.append("Ouça aqui!");
    raPlayer.append(raButton);
    ttsContainer.append(raPlayer);
    ttsButton.setAttribute("ttson", "true");
  }
}

const textToSpeechFunc = () => {
  document.addEventListener("DOMContentLoaded", function () {
    renderButton();
    var ttsButton = document.getElementById("tts-button");
    if (ttsButton) {
      ttsButton.addEventListener("click", function () {
        handleTTS();
      });
    }
  });
};

export { textToSpeechFunc };
