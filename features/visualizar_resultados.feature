# language: pt

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
