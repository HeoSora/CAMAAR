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
