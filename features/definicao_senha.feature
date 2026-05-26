# language: pt

@Issue-12

Funcionalidade: Sistema de definição de senha
    Eu como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema

    Cenário: [Feliz] Definir senha com link válido
        Dado que recebo um e-mail com um link de definição de senha válido
        Quando eu acesso o link e preencho o campo "Nova Senha" com uma senha válida
        E confirmo a senha no campo "Confirmar Senha"
        E o campo "Nova senha" não está vazio 
        Então a senha deve ser definida com sucesso
        E eu devo conseguir acessar o sistema utilizando a nova senha

    Cenário: [Triste] Tentar definir senha com link inválido
        Dado que recebo um e-mail com um link de definição de senha inválido ou expirado
        Quando eu tento acessar o link para definir minha senha
        Então devo ver uma mensagem "Link de definição de senha inválido ou expirado"
        E não devo conseguir definir minha senha

    Cenário: [Triste] Senha inválida
        Dado que recebo um e-mail com um link de definição de senha válido
        Quando eu acesso o link e preencho o campo "Nova Senha" com uma senha válida
        E confirmo a senha no campo "Confirmar Senha"
        E o campo "Nova senha" está vazio 
        Então devo ver a mensagem "Senha inválida"
        E eu não conseguir acessar o sistema utilizando a nova senha

