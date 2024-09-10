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

function renderNews(apiData, idComponent, idProcess, highlightLatest, descButton) {
  const newsData = apiData.data.participatoryProcesses;
  const resultHTMLArray = [];
  const slug = apiData.data.participatoryProcesses[0].slug;
  const href = `/processes/${slug}/f/${idComponent}`;

  newsData.forEach((process) => {
    process.components.forEach((component) => {
      if (component.posts) {
        component.posts.nodes.forEach((post, index) => {

          if (index === 0 && highlightLatest) {
            return;
          }

          const imageUrl = post.attachments.length > 0 ? post.attachments[0].thumbnail : "";
          const newHTML = `
          <a href="${href}/posts/${post.id}" class="page-news-card">
            <img src="${imageUrl}" alt="" class="news-img"/>

            <div class="page-news-card-content">
              <span class="news-title">${post.title.translation}</span>
            </div>
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

  const highlightedNew = newsData[0].components[0].posts.nodes[0];
  const imageUrl = highlightedNew.attachments.length > 0 ? highlightedNew.attachments[0].thumbnail : "";
    
  //remove as tags html do texto
  highlightedNew.body.translation = highlightedNew.body.translation.replace(/<\/?[^>]+(>|$)/g, "");

  // convertendo de data ISO para data de acordo com o formato do front
  // let highlightedNewDate = highlightedNew.createdAt.split("T")[0]; 
  // highlightedNewDate = highlightedNewDate.split("-").reverse().join("/");

  const highlightedNewComponent = () => {
    if (highlightLatest) {
      const highlightedNewHTML = `
        <a class="main-news-card" href="${href}/posts/${highlightedNew.id}">
          <img src="${imageUrl}" alt="" class="main-news-img"/>
          <div class="main-news-content">
            <div class="main-news-header">
            <span class="main-news-title">${highlightedNew.title.translation}</span>
            <span class="main-news-subtitle">${highlightedNew.body.translation}</span>
            </div>
          </div>
        </a>
      `;

      return highlightedNewHTML;
    }

    return "";
  }

  return `<div class="home-sections-content">

            ${highlightedNewComponent()}
            <div class="news-container">
              ${resultHTMLArray.join("\n")}
            </div>
            <div class="centered-content">
              <a href="${href}" class="br-button secondary">${descButton}</a>
            </div>
          </div>`;

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
   * @param {boolean} highlightLatest - Se deve realçar a última notícia ou não. ex: true
   */
function manageNews(apiUrl, idComponent, idProcess, title, descButton, highlightLatest) {
  const confNoticias = document.querySelector("#confnoticias");
  if (!confNoticias) {
    console.error('Elemento com id "confnoticias" não encontrado.');
    return;
  }

  const numberOfNews = highlightLatest ? 4 : 3;
  
  confNoticias.innerHTML = `<section id="news-home-section" class="home-sections-container">
                                <h2>${title}</h2>
                                <div class="page-news-error">
                                    <div class="news-container">
                                        <span class="news-title">Carregando...</span>
                                    </div>
                                </div>
                            </section>`; 

  const query = `query {
    participatoryProcesses(filter: { id: ${idProcess} }) {
      slug
      components(filter: { id: ${idComponent} }) {
        ...on Blogs {
          posts(order: {createdAt: "DESC"}, first: ${numberOfNews}) {
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
              createdAt
              id
            }
          }
        }
      }
    }
  }`;

  fetchGraphQLData(apiUrl, query)
    .then((apiData) => renderNews(apiData, idComponent, idProcess, highlightLatest, descButton))
    .then((renderedNewsHTML) => {
      if (renderedNewsHTML === "error" || renderedNewsHTML === "") {
        confNoticias.innerHTML = `<section id="news-home-section" class="home-sections-container">
                                      <h2>${title}</h2>
                                      <div class="page-news-error">
                                          <div class="news-container">
                                              <span class="news-title">Nenhuma notícia encontrada</span>
                                          </div>
                                      </div>
                                  </section>`; 
      } else {
        let contentNoticias = `<section id="news-home-section" class="home-sections-container">
                                  <h2>${title}</h2>                    
                                      ${renderedNewsHTML}                        
                               </section>`;
        confNoticias.innerHTML = contentNoticias;
      }
    })
    .catch((error) => {
      console.error("Erro:", error);
      confNoticias.innerHTML = `<section id="news-home-section" class="home-sections-container">
                                    <h2>${title}</h2>
                                    <div class="page-news-error">
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
