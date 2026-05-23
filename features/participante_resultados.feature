# language: pt

Feature: Visualização de formulários para responder
  Como discente
  Quero visualizar a lista de formulários disponíveis
  A fim de saber quais avaliações eu preciso responder no semestre letivo

  Cenário: [Feliz] Visualizar a lista de formulários disponíveis para resposta
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    Quando eu acesso a aba de "Formulários Pendentes"
    Então eu devo ver uma lista com os formulários das minhas disciplinas matriculadas
    E o formulário da turma "CIC0097 - BANCOS DE DADOS" deve estar com o status "Aberto"

  Cenário: [Triste] Tentar visualizar formulários não estando matriculado em disciplinas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    Mas o sistema registra que eu não possuo matrícula ativa no semestre atual
    Quando eu acesso a aba de "Formulários Pendentes"
    Então eu devo ver a mensagem "Você não possui formulários pendentes para este semestre"


Feature: Responder formulário
  Como discente
  Quero preencher e enviar os formulários de avaliação
  A fim de registrar meu feedback sobre as disciplinas e docentes

  Cenário: [Feliz] Responder um formulário com todos os dados válidos
    Dado que eu estou na página de resposta do formulário da turma "CIC0097 - BANCOS DE DADOS"
    Quando eu preencho todas as perguntas obrigatórias com o valor "5"
    E eu envio o formulário
    Então o sistema deve exibir a mensagem "Avaliação enviada com sucesso"
    E o formulário deve sumir da minha lista de pendentes

  Cenário: [Triste] Tentar enviar um formulário com campos obrigatórios vazios
    Dado que eu estou na página de resposta do formulário da turma "CIC0105 - ENGENHARIA DE SOFTWARE"
    Quando eu deixo a pergunta "Avaliação do Docente" em branco
    E eu tento enviar o formulário
    Então o sistema deve exibir a mensagem de erro "Todos os campos obrigatórios devem ser preenchidos"
    E o formulário não deve ser computado

  Cenário: [Triste] Tentar preencher o formulário com notas fora do intervalo permitido
    Dado que eu estou na página de resposta do formulário da turma "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    Quando eu insiro o valor "6" em uma das perguntas de nota
    E eu tento enviar o formulário



Feature: Visualização de resultados dos formulários
  Como administrador
  Quero visualizar os resultados parciais ou totais de uma turma
  A fim de acompanhar o andamento e o consolidado das avaliações anonimamente

  Cenário: [Feliz] Visualizar resultados parciais de um formulário de turma
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    Quando eu acesso a página de "Resultados das Avaliações"
    E eu busco pelos resultados da turma "CIC0097"
    Então eu devo visualizar um painel com a média das notas e os comentários anonimizados

  Cenário: [Triste] Tentar visualizar resultados de uma turma sem avaliações submetidas
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"
    Quando eu acesso a página de "Resultados das Avaliações"
    E eu busco pelos resultados de uma turma que não teve nenhuma participação dos alunos
    Então eu devo ver a mensagem "Ainda não há dados suficientes para gerar a visualização desta turma"
    Então o sistema deve bloquear o envio
    E exibir a mensagem "Por favor, insira um valor válido entre 1 e 5"
