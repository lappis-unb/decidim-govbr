function fetchGraphQLData(url, query) {
  const headers = {
    "Content-Type": "application/json",
    Accept: "application/json",
  };

  const body = JSON.stringify({ query });

  return fetch(url, {
    method: "POST",
    headers: headers,
    body: body,
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      return response.json();
    })
    .catch((error) => {
      throw new Error(`Error in GraphQL query: ${error.message}`);
    });
}

function renderNews(apiData, href) {
  const newsData = apiData.data.participatoryProcesses;
  const resultHTMLArray = [];

  newsData.forEach((process) => {
    process.components.forEach((component) => {
      if (component.posts) {
        component.posts.nodes.forEach((post) => {
          const imageUrl = post.attachments.length > 0 ? post.attachments[0].thumbnail : "";
          const newHTML = `
          <a href="${href}" class="news-card">
            <img src="${imageUrl}" alt="" class="news-img"/>
            <span class="news-title">${post.title.translation}</span>
          </a>
          `;

          resultHTMLArray.push(newHTML);
        });
      }
    });
  });

  if (resultHTMLArray.length === 0) {
    return "error";
  }

  return resultHTMLArray.join("\n");
}
  /**
   * Busca dados de notícias da API GraphQL e os renderiza na página.
   *
   * @param {string} apiUrl - A URL da API GraphQL. em localhost é http://localhost:3000/api
   * @param {string} href - O valor href para o link de mais notícias. ex: "http://localhost:3000/processes/teste/f/32/" 
   * @param {number} idComponent - O ID do componente. ex: 1
   * @param {number} idProcess - O ID do processo participativo. ex: 32
   * @param {string} title - O título da seção de notícias. ex: "Notícias"
   * @param {string} descButton - A descrição do botão de notícias. ex: "Mais notícias"
   */
function manageNews(apiUrl, href, idComponent, idProcess, title, descButton) {
  const confNoticias = document.querySelector("#confnoticias");
  if (!confNoticias) {
    console.error('Elemento com id "confnoticias" não encontrado.');
    return;
  }
  
  confNoticias.innerHTML = `<section id="news-home-section" class="home-sections-container">
                                <h2>${title}</h2>
                                <div class="home-sections-content br-container-lg">
                                    <div class="news-container">
                                        <span class="news-title">Carregando...</span>
                                    </div>
                                </div>
                            </section>`; 

  const query = `query {
    participatoryProcesses(filter: { id: ${idProcess} }) {
      components(filter: { id: ${idComponent} }) {
        ...on Blogs {
          posts(order: {createdAt: "DESC"}, first: 3) {
            nodes {
              title {
                translation(locale: "pt-BR")
              }
              body {
                translation(locale: "pt-BR")
              }
              attachments {
                thumbnail
              }
            }
          }
        }
      }
    }
  }`;

  fetchGraphQLData(apiUrl, query)
    .then((apiData) => renderNews(apiData, href))
    .then((renderedNewsHTML) => {
      if (renderedNewsHTML === "error") {
        confNoticias.innerHTML = `<section id="news-home-section" class="home-sections-container">
                                      <h2>${title}</h2>
                                      <div class="home-sections-content br-container-lg">
                                          <div class="news-container">
                                              <span class="news-title">Nenhuma notícia encontrada</span>
                                          </div>
                                      </div>
                                  </section>`; 
      } else {
        let contentNoticias = `<section id="news-home-section" class="home-sections-container">
                                  <h2>${title}</h2>
                                  <div class="home-sections-content br-container-lg">
                                    <div class="news-container">
                                      ${renderedNewsHTML}
                                    </div>
                                    <div class="centered-content">
                                      <a href="${href}" class="br-button secondary">${descButton}</a>
                                    </div>
                                  </div>
                               </section>`;
        confNoticias.innerHTML = contentNoticias;
      }
    })
    .catch((error) => {
      console.error("Erro:", error);
      confNoticias.innerHTML = `<section id="news-home-section" class="home-sections-container">
                                    <h2>${title}</h2>
                                    <div class="home-sections-content br-container-lg">
                                        <div class="news-container">
                                            <span>Erro ao buscar notícias.</span>
                                        </div>
                                    </div>
                                </section>`; 
    });
}

window.manageNews = {
    manageNews: manageNews,
};

export { manageNews };
