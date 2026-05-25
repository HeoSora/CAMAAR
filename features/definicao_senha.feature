#language: pt

#Issue - 12

Funcionalidade: Sistema de definição de senha
    Eu como Usuário
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
    A fim de acessar o sistema

    Regras de Negócios:
        - Um usuário recém-cadastrado deve definir sua senha antes de acessar o sistema
        - A definição de senha deve ocorrer a partir do link recebido por e-mail
        - O sistema deve validar se o link de definição de senha é válido
        - O sistema não deve receber senha vazias
        - O sistema deve  salvar a senha de forma segura
        - Após a definição de senha, o usuário deve conseguir acessar o sistema.

    Cenario: [Feliz] Definir senha com link válido
        Dado que recebo um e-mail com um link de definição de senha válido
        Quando eu acesso o link e preencho o campo "Nova Senha" com uma senha válida
        E confirmo a senha no campo "Confirmar Senha"
        Então a senha deve ser definida com sucesso
        E eu devo conseguir acessar o sistema utilizando a nova senha


    Cenário: [Triste] Tentar definir senha com link inválido
        Dado que recebo um e-mail com um link de definição de senha inválido ou expirado
        Quando eu tento acessar o link para definir minha senha
        Então devo ver uma mensagem "Link de definição de senha inválido ou expirado"
        E não devo conseguir definir minha senha