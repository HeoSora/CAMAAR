# language: pt

Feature: Gerar relatório do administrador
  Como administrador
  Quero gerar um relatório consolidado do semestre
  A fim de obter um documento oficial com as métricas de todas as turmas avaliadas

  Cenário: [Feliz] Gerar relatório consolidado do semestre
    Dado que eu estou na página de "Geração de Relatórios" como administrador
    Quando eu seleciono o período letivo de "2021.2"
    E eu aciono a opção "Gerar Relatório Geral"
    Então o sistema deve compilar os dados de todas as turmas
    E iniciar automaticamente o download de um arquivo contendo o relatório do semestre

  Cenário: [Triste] Tentar gerar relatório com filtros de período inválidos
    Dado que eu estou na página de "Geração de Relatórios"
    Quando eu defino uma data final que é anterior à data inicial nos filtros de busca
    E eu aciono a opção "Gerar Relatório Geral"
    Então o sistema deve exibir a mensagem de erro "Período inválido: a data final não pode ser anterior à inicial"
    E a geração do relatório deve ser interrompida
