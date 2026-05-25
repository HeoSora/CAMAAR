#language: pt

#Issue 10

Funcionalidade: Redefinição de senha
    Eu como Usuário
    Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
    A fim de recuperar o meu acesso ao sistema

    Regras de Negócio:
        - O usuário deve conseguir solicitar a redefinição de senha pelo e-mail cadastrado
        - O sistema deve enviar um link de redefinição para o e-mail do usuário
        - O sistema não deve permitir redefinição com link invalido ou expirado
        - A nova senha não podem ser vazias
        - Após redefinir a senha, a senha anterior não deve mais permitir acesso
        - O usuário deve conseguir fazer login com a nova senha

    Cenario: [Feliz] Redefinir senha com link valido
        Dado que recebo um e-mail com um link de redefinição de senha válido
        Quando eu acesso o link e preencho o campo "Nova Senha" com uma senha válida
        E confirmo a senha no campo "Cadastrar Nova Senha"
        Então a senha deve ser redefinida com sucesso
        E eu devo conseguir acessar o sistema utilizando a nova senha
        Mas não devo conseguir acessar o sistema com a senha anterior
    
    Cenario: [Triste] Tentar redefinir senha com link inválido
        Dado que recebo um e-mail com um link de redefinição de senha inválido ou expirado
        Quando eu tento acessar o link para redefinir minha senha
        Então devo ver uma mensagem "Link de redefinição de senha inválido ou expirado"
        E não devo conseguir redefinir minha senha



