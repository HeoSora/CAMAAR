#language: pt

#Issue-19

Feature: Importar dados do SIGAA
  Como administrador acadêmico
  Quero importar dados do SIGAA
  A fim de cadastrar informações acadêmicas no sistema

  Scenario: Caminho feliz
    Dado que o sistema está conectado ao SIGAA
    E existem dados disponíveis para importação
    Quando o administrador solicitar a importação
    Então os dados devem ser importados com sucesso
    E armazenados na base de dados

  Scenario: Caminho triste
    Dado que o SIGAA está indisponível
    Quando o administrador solicitar a importação
    Então o sistema deve exibir uma mensagem de erro
    E nenhum dado deve ser salvo
