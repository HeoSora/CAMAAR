# language: pt

Funcionalidade: Visualização dos templates criados
  Como administrador
  Quero visualizar os templates de formulário existentes
  A fim de gerenciar e utilizar os templates disponíveis

  Contexto:
    Dado que eu estou logado no sistema CAMAAR com o perfil de "administrador"

  Cenário: [Feliz] Administrador visualiza listagem de templates cadastrados
    Dado os seguintes templates estão cadastrados no sistema:
      | nome                        | semestre |
      | Avaliação Docente           | 2024.1   |
      | Avaliação de Infraestrutura | 2024.2   |
    Quando eu acesso a página de gerenciamento de templates
    Então eu devo ver uma grade com os templates cadastrados
    E cada card deve exibir o nome, o semestre, o ícone de editar e o ícone de deletar

  Cenário: [Feliz] Administrador acessa a tela sem nenhum template cadastrado
    Dado não há nenhum template cadastrado no sistema
    Quando eu acesso a página de gerenciamento de templates
    Então eu não devo ver nenhum card de template na grade
    E eu devo ver apenas o card "+" para criação de um novo template

  Cenário: [Triste] Discente recebe mensagem de erro ao tentar acessar templates
    Dado que eu estou logado no sistema CAMAAR com o perfil de "discente"
    Quando eu acesso a URL de gerenciamento de templates
    Então o sistema deve exibir a mensagem "Você não tem permissão para acessar esta página"
    E eu devo ser redirecionado para a página inicial do meu perfil
