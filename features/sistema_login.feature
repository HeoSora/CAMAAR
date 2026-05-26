# language: pt

#Issue - 13
Funcionalidade: Sistema de Login
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Cenário: [Feliz] Credencial de usuário comum válido
        Dado que acesso o formulário de "Login"
        Quando eu preencher o campo de "E-mail ou matrícula" com um e-mail ou matrícula cadastrados
        E no campo "Senha" a senha válida
        E utilizar credenciais do perfil "Discente"
        Então devo ser redirecionado para a página com perfil de "Discente"
        E não devo ver a opção de "Gerenciamento" no menu lateral

    Cenário: [Feliz] Credencial de usuário administrador vÁlido 
        Dado que acesso o formulário de "Login"
        Quando eu preencher o campo de "E-mail ou matrícula" com um e-mail ou matrícula cadastrados
        E no campo "Senha" a senha válida
        E utilizar credenciais do perfil "administrador"
        Então devo ser redirecionado para a página com perfil de "administrador" 
        E devo ver a opção de "Gerenciamento" no menu lateral

    Cenário: [Triste] Usuário inválido
        Dado que acesso o formulário de "Login"
        E preencho os campos de "Usuário"
        Quando tentar entrar com um usuário não cadastrado 
        Então devo ver uma mensagem "Usuário e/ou senha inválidos"

    Cenário: [Triste] Senha inválida
        Dado que acesso o formulário de "Login"
        E preencho o campo "Senha" 
        Quando tentar preencher com uma senha incorreta
        Então devo ver uma mensagem "Usuário e/ou senha inválido"


