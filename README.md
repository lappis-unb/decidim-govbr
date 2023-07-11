# Plataforma Brasil Participativo - Um país com a cara do povo

Brasil Participativo é a nova plataforma digital do governo federal, um espaço para que a população possa contribuir com a criação e melhoria das políticas públicas. 

A Plataforma contou com a parceria do Ministério da Gestão e da Inovação em Serviços Públicos, e foi desenvolvida com o apoio da Dataprev, da Universidade de Brasilia (UnB) da comunidade Decidim-Brasil. Essa versão é uma evolução do fork do projeto desenvolvido pela [Nomade](https://gitlab.com/nomadetec/decide).

O Laboratório Avançado de Pesquisa e Desenvolvimento de Software (LAPPIS) da Faculdade UnB Gama (FGA) estabeleceu um método que facilita a participação de alunos do curso de engenharia de software em projetos cívicos de software livre como instrumento pedagógico. Coordenado por professores com experiência na participação de comunidades, desenvolvimento de softwares livres e métodos ágeis, foi o parceiro de desenvolvimento de projetos importantes do governo federal como o Portal do Software Público, Participa.br, Aplicativo da Conferência da Juventude e Dialoga Brasil.

Todos esses projetos foram evoluções do projeto de Software Livre Noosfero, um projeto brasileiro desenvolvido em Ruby on Rails, pela [Colivre](https://pt.wikipedia.org/wiki/Noosfero). Essa nova parceria entre a Secretaria Nacional de Participação Social e o Lappis para o desenvolvimento da plataforma Brasil Participativo, dá continuidade a esse histórico de participação digital no Brasil utilizando software livre. O Objetivo dessa parceria é a consolidação de Laboratório de Inovação para Participação com capacidade de desenvolver e implementar estratégias e ferramentas de participação digital que possam ser (re)utilizadas pelos demais órgãos do governo.

Democracia participativa de código aberto, participação cidadã e governo aberto para cidades e organizações

Este é o repositório de código aberto para o decide, baseado no [Decidim](https://github.com/decidim/decidim).

# Getting Started

## Configurando a aplicação

Você precisará seguir algumas etapas antes de fazer com que o aplicativo funcione corretamente:

1. Abra um console Rails no servidor:  `bundle exec rails console`
1. Crie um usuário administrador do sistema:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```

1. Visite `<your app url>/system`  e faça login com suas credenciais de administrador do sistema
1. Crie uma nova organização. Marque os idiomas que deseja usar para essa organização e selecione um idioma padrão.
Defina o host padrão correto para a organização, caso contrário, o aplicativo não funcionará corretamente. Observe que você precisa incluir qualquer subdomínio que possa estar usando.

1. Preencha o restante do formulário e envie.

Agora você está pronto!

Caso você queira um tutorial passo a passo, fizemos um bem detalhado na [wiki do repositório](https://gitlab.com/lappis-unb/decidimbr/decidim-govbr/-/wikis/home)

# Subindo o Sidekiq e o Mailcatcher
Duas ferramentas serão necessárias durante a utilização do ambiente de desenvolvimento: o *sidekiq* e o *mailcatcher*. O *sidekiq* é uma gem ruby que fornece um mecanismo de processamento de jobs ou tarefas em segundo plano.

Suba o mailcatcher com o comando

```
mailcatcher
```

Em seguida, suba o *sidekiq* com o comando:

```
docker compose up -d
foreman start
```

#  Criando espaços de participação digital

Se você quiser testar os módulos da plataforma, criando espaços participativos e seus componentes participativos, estamos documentando alguns tutoriais na nossa [wiki](https://gitlab.com/groups/lappis-unb/decidimbr/-/wikis/Documentação).

# Ambientes

O ambiente de produção do projeto pode ser acessado [aqui](https://brasilparticipativo.presidencia.gov.br).

O ambiente de lab/dev   pode ser acessado [aqui](https://lab-decide.dataprev.gov.br).

Para criar usuário no ambiente dev, entrar em contato com algum dos mantenedores da plataforma.

# Código de conduta

Acreditamos firmemente que a diversidade de pessoas contribuindo para um projeto é fundamental para garantir a qualidade do software. Com o objetivo de desenvolver uma plataforma de participação digital acessível a todos os brasileiros, reconhecemos a importância de um cuidadoso processo de desenvolvimento do software, buscando envolver a maior diversidade possível de colaboradores.

Para alcançar esse objetivo, valorizamos a criação de um ambiente de colaboração acolhedor e seguro. Nesse sentido, implementamos um [código de conduta], que é rigorosamente aplicado. Através desse código, esperamos estabelecer uma comunidade de software livre que promova desafios técnicos estimulantes, ofereça mentoring de qualidade e faça com que todos se sintam pertencentes e valorizados.

Nosso código de conduta é essencial para garantir que todos os colaboradores tenham uma experiência positiva, livre de discriminação, assédio ou qualquer forma de comportamento prejudicial. Ao adotar esses princípios, podemos fomentar uma cultura inclusiva que celebra a diversidade de ideias, perspectivas e origens.

Estamos comprometidos em criar um ambiente colaborativo onde todos possam contribuir com seus conhecimentos e habilidades, independentemente de sua identidade, gênero, orientação sexual, etnia, religião ou qualquer outra característica individual. Através desse engajamento diversificado, temos a certeza de que seremos capazes de desenvolver um software de alta qualidade que atenda às necessidades e expectativas de todos os brasileiros.

Contamos com você para fazer parte dessa comunidade inclusiva e construir uma plataforma de participação digital verdadeiramente acessível e abrangente. 

# Quer contribuir ?!

Achou interessante o projeto? Ta querendo aprender Ruby on Rails? Quer conhecer brasileiros que contribuem para software livre?

Tem várias ``Good first issues`` pensadas em facilitar sua contribuição. 

No nosso [Guia de Contribuição] tem o passo a passo em como iniciar sua contribuição na comunidade

# Licença
