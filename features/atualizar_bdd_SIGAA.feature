#language: pt

#Issue-9

Feature: Atualizar base de dados com os dados do SIGAA
  Como administrador acadêmico
  Quero atualizar os dados já cadastrados
  A fim de manter a base sincronizada com o SIGAA

  Scenario: Caminho feliz
    Given que existem novos dados disponíveis no SIGAA
    And a base local possui registros antigos
    When o administrador solicitar a atualização
    Then os registros devem ser sincronizados
    And a base local deve refletir os novos dados

  Scenario: Caminho triste
    Given que ocorreu falha de comunicação com o SIGAA
    When o administrador solicitar a atualização
    Then o sistema deve informar falha na sincronização
    And a base local deve permanecer inalterada
