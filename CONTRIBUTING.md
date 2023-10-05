# Guia de Contribuição

Ao criar um pull request neste repositório, você concorda com [nosso código de conduta](CODE-OF-CONDUCT.md), que promove um ambiente de colaboração inclusivo, respeitoso e livre de discriminação. Valorizamos a diversidade de colaboradores para criar uma plataforma acessível a todos os brasileiros. Seu compromisso em seguir esses princípios é essencial para mantermos uma cultura positiva e acolhedora.

## Organização Geral do Projeto

O projeto apresenta uma organização típica de um projeto Ruby on Rails. O Rails é um framework de desenvolvimento web escrito em Ruby, criado para simplificar o desenvolvimento de aplicações web. Ele se destaca por seu objetivo de reduzir a quantidade de código necessário para realizar tarefas comuns, aumentando a produtividade dos desenvolvedores. Além disso, o Ruby on Rails segue o padrão Model-View-Controler (MVC), funcionando com modelos que representam dados, controladores que gerenciam requisições e visões que exibem informações. O roteamento direciona solicitações, e migrações modificam o banco de dados, além de permitir a escrita de testes automatizados. É possível ler mais no [Guia de Rails](https://guides.rubyonrails.org/getting_started.html).


## Como contribuir

É possível contribuir com nosso projeto com código, documentação, organização, entre outros aspectos. As duas principais ferramentas para o desenvolvimento são:

1. Issues: onde os contribuidores discutem tarefas e problemas relacionados ao projeto. É o local onde você pode encontrar e acompanhar as discussões sobre o que precisa ser feito.
2. Pull Requests: : Esta é a área onde os colaboradores discutem e revisam as alterações que estão em andamento. É onde você pode enviar suas contribuições e receber feedback da comunidade.

Antes de abrir uma issue ou pull request, é importante que:

- Comunique suas ideias de maneira clara e eficaz, explicando o que pretende fazer, fornecendo contexto sobre sua ideia e como ela beneficia o projeto;
- Consulte o README, analise as issues e pull requests que estão abertas e as que foram fechadas anteriormente, e explore outros canais de comunicação da comunidade para entender o contexto e as discussões já realizadas no projeto. Isso ajuda a evitar duplicações e contribuir de forma mais informada;

### Abrindo uma issue

Quando você cria uma issue, é importante fornecer:
- um título conciso, mas informativo, que capture a essência do problema. 
- uma descrição detalhada do que precisa ser feito e, se possível, mencione quaisquer artefatos relevantes que possam auxiliar na resolução da issue. Isso ajuda a garantir que a questão seja compreendida com clareza e que os colaboradores possam tomar as medidas necessárias de forma eficaz.
- labels para categorizar a issue. Por exemplo, você pode usar etiquetas como "Brasil-Participativo" para indicar o contexto do projeto, "Bug" para problemas, "DEV" para desenvolvimento, "Front-end" ou "Engenharia de Dados" para especificar a área de atuação, "Good-First-Issue" para issues adequadas para novos colaboradores, etc.


### Abrindo um Pull Request

Após clonar o repositório:

- crie uma nova branch para suas modificações. Use um nome descritivo que indique o que está sendo trabalhado, como git checkout -b nome-da-sua-branch
- referencie issues relevantes: Se sua contribuição estiver relacionada a alguma issue existente, referencie-a em seu pull request. Isso pode ser feito usando algo como "Fechando #[número da issue]" em sua descrição;
- teste suas modificações localmente para evitar introduzir problemas no projeto. Verifique se tudo está funcionando conforme o esperado.
- ao contribuir com o estilo do projeto, mantenha-se alinhado com os padrões e estilos de código existentes no projeto. Siga as diretrizes de estilo estabelecidas pela comunidade para manter a consistência;
- crie o Pull Request: Quando suas modificações estiverem prontas, faça o push da sua branch para o repositório remoto com git push origin nome-da-sua-branch. Em seguida, acesse o repositório no GitHub e você verá a opção de criar um pull request. Preencha os detalhes do pull request, incluindo uma descrição clara do que foi feito.

- aguarde a revisão de outros colaboradores do projeto. Eles podem sugerir alterações ou aprovar suas modificações.

- mantenha o Pull Request Atualizado: Se forem solicitadas alterações, faça as modificações em sua branch e atualize o pull request. Mantenha o diálogo e a colaboração durante o processo.

## Política de Branchs

A branch "main" é a versão estável do projeto, onde o código de produção é mantido. Não é possível fazer commits ou push diretamente para essa branch. Em vez disso, as alterações na "main" devem ser introduzidas por meio de solicitações de merge (merge requests) provenientes de outras branches, que resolvem problemas específicos.

### Nomenclatura de Branch

Ao criar uma nova branch, é importante que o padrão de nomenclatura descrito abaixo seja seguido:

1. Escolha uma categoria: Comece selecionando uma categoria para sua branch. Você pode escolher entre "feature" (recurso), "bugfix" (correção de bug), "hotfix" (correção urgente), "test" (teste) ou "docs" (documentação).
2. Inclua a Referência: Após a categoria, adicione uma barra ("/") e insira a referência da issue que a branch soluciona. Se não houver uma referência, use "no-ref".
3. Descreva o Propósito: Após outra barra ("/"), forneça uma breve descrição que resuma o objetivo específico dessa branch. Certifique-se de usar "kebab-case" (com traços entre as palavras) para a descrição.

Exemplo:
```
git branch <categoria/referência/descrição-em-kebab-case>
```

## Política de Commits

A política de commits foi estabelecida seguindo as diretrizes descritas no [Conventional Commits](https://www.conventionalcommits.org/pt-br/v1.0.0/). Essa especificação define um conjunto de regras simples para formatar mensagens de commit de forma explícita. Isso ajuda na criação de um histórico de commits organizado e facilita o desenvolvimento de ferramentas automatizadas que utilizam essa especificação como base.

A estrutura para mensagem de commit é a seguinte:
```
<tipo>[escopo opcional]: <descrição>

[corpo opcional]

[rodapé(s) opcional(is)]
```

### Tipo

Os *tipos* podem ser:

- build: alterações que afetam o sistema de build ou dependências externas
- static: alterações no conteúdo de arquivos estáticos (dados .json, imagens, etc)
- ci: alterações em nossos arquivos e scripts de configuração de CI
- cd: alterações em nossos arquivos e scripts de configuração para CD
- docs: somente alterações na documentação
- feat: um novo recurso
- fix: uma correção de bug da aplicação
- perf: alteração de código que melhora o desempenho da aplicação e não altera a forma como o usuário utiliza a aplicação
- refactor: alteração de código, que não corrige um bug e nem altera a forma como o usuário utiliza a aplicação
- improve: alguma alteração de código que melhore o comportamento de um recurso
- style: alterações que não afetam o significado do código (espaço em branco, formatação, ponto e vírgula, etc)
- test: adicionando testes ausentes ou corrigindo testes existentes
- revert: reverter para um commit anterior

### Descrição

- Deve ser uma descrição breve da alteração;
- Use o tempo presente e o modo imperativo, como "alterar";
- Não inicie com letra maiúscula;
- Não coloque um ponto (.) no final da descrição;

### Corpo

- Você pode adicionar um corpo de mensagem de commit mais detalhado, se necessário, após o título.
- Use o corpo para explicar o "o quê" e "por quê" das alterações realizadas, em vez de detalhar o "como".
- O corpo deve começar após uma linha em branco que segue a descrição do commit.
- Opcionalmente, você pode adicionar um rodapé após outra linha em branco, caso haja informações adicionais relevantes.