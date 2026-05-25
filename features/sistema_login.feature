#language: pt

#Issue - 13
Funcionalidade: Sistema de Login
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    Regras de Negócio:
        - O usuário deve conseguir acessar o sistema usuando e-mail ou matricula e senha cadastrado
        - O sistema não deve permitir acesso com senha incorreta
        - O sistema não deve permitir acesso com usuário não cadastrado
        - Apos o login valido, o usuário deve ser redirecionado conforme seu perfil
        - Usuarios com perfil administrador devem visualizar a opção de gerenciamento no menu lateral
        - Usuarios com perfil discentes não devem visualizar opções administrativas


    Cenario: [Feliz] Credencial de usuario comum valido
        Dado que acesso o formulário de "Login"
        Quando eu preencher o campo de "Nome de usuario" com um e-mail ou matrícula cadastrados
        E no campo "Senha" a senha válida
        E utilizar credenciais do perfil "Discente"
        Então devo ser redirecionado para a pagina com perfil de "Discente"
        Mas não devo ver a opção de "gerenciamento" no menu lateral

    Cenario: [Feliz] Credencial de usuario administrador valido 
        Dado que acesso o formulário de "Login"
        Quando eu preencher o campo de "Nome de usuario" com um e-mail ou matrícula cadastrados
        E no campo "Senha" a senha válida
        E utilizar credenciais do perfil "administrador"
        Então devo ser redirecionado para a pagina com perfil de "administrador" 
        E devo ver a opção de "gerenciamento" no menu lateral

    Cenario: [Triste] Usuario inválido
        Dado que acesso o formulário de "Login"
        E preencho os campos de "Usuario"
        Quando tentar entrar com um o usuario não cadastrado 
        Então devo ver uma mensagem "Usuário e/ou senha inválido"

    Cenario: [Triste] Senha inválida
        Dado que acesso o formulário de "Login"
        E preencho o campo "Senha" 
        Quando tentar preencher com uma senha incorreta
        Então devo ver uma mensagem "Usuário e/ou senha inválido"


