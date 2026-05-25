#language: pt

#Issue-17

Funcionalidade: Cadastrar usuarios do sistema
    Eu como Administrador
    Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
    A fim de que eles acessem o sistema CAMAAR

    Nesta issue é importante lembrar que apesar de estar sendo citado como cadastro de usuário, 
    o que é feito é a solicitação da definição da senha do usuário.
    O cadastro do aluno/professor como usuário só é realmente efetivado após a definição 
    da senha.

    Regras de Negócio:
        - O administrador deve conseguir cadastrar usuários a partir dos dados importados do SIGAA
        - Usuarios já existentes não devem ser duplicados
        - O cadastro inicial deve gerar uma solicitação de definição de senha
        - O usuário só deve ser considerado apto a acessar o sistema após definir a sua senha
        - O sistema deve associar corretamente o usuario ao seu perfil
        - O sistema deve manter vinculo entre usuário, turma, matriculo e departamento quando aplicavel


    Cenario: [Feliz] Cadastrar usuario com dados válidos
        Dado que eu acesso a opção de "gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo CSV contendo os dados de novos usuários do SIGAA
        E os dados estão formatados corretamente e correspondem a novos usuários no SIGAA
        Então o sistema deve processar o arquivo e criar solicitações de definição de senha para cada usuário novo
        E os usuários devem receber um e-mail com um link para definir suas senhas

    Cenario: [Feliz] Usuário define sua senha após cadastro
        Dado que um usuário recebeu um e-mail com um link para definir sua senha após o cadastro
        Quando o usuário clica no link e é redirecionado para a página de definição de senha
        E o usuário insere uma nova senha válida e confirma a senha
        Então o usuário deve ser capaz de acessar o sistema com suas credenciais

    Cenario: [Triste] Tentar cadastrar usuario com dados inválidos
        Dado que eu acesso a opção de "gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo CSV contendo os dados de novos usuários do SIGAA
        E os dados estão formatados incorretamente ou não correspondem a usuários existentes no SIGAA
        Então o sistema deve exibir uma mensagem de erro "Erro: Dados inválidos"
        E o sistema não deve criar solicitações de definição de senha para os usuários 

    Cenario: [Triste] Tentar cadastrar usuario já existente
        Dado que eu acesso a opção de "gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo CSV contendo os dados de novos usuários do SIGAA
        E os dados estão formatados corretamente mas correspondem a usuários já existentes no sistema
        Então o sistema deve exibir uma mensagem de aviso "Aviso: Usuário já existe"
        E o sistema não deve criar solicitações de definição de senha para os usuários duplicados



