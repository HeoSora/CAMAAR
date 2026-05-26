#language: pt

#Issue-11

Feature: Sistema de gerenciamento por departamento
  Como administrador acadêmico
  Quero gerenciar os dados por departamento
  A fim de organizar as informações acadêmicas

  Scenario: Caminho feliz
    Given que existem departamentos cadastrados
    When o administrador selecionar um departamento
    Then o sistema deve exibir os dados correspondentes

  Scenario: Caminho triste
    Given que o departamento selecionado não possui registros
    When o administrador realizar a consulta
    Then o sistema deve informar que não há dados disponíveis
