# language: pt

@Issue-17

Funcionalidade: Cadastrar usuários do sistema
    Eu como Administrador
    Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
    A fim de que eles acessem o sistema CAMAAR

    Cenário:[Feliz] Cadastrar usuário com dados válidos
        Dado que eu acesso a opção de "Gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo JSON contendo os dados de novos usuários do SIGAA
        E os dados estão válidos no arquivo importado 
        Então o sistema deve processar o arquivo e criar solicitações de definição de senha para cada usuário novo
        E os usuários devem receber um e-mail com um link para definir suas senhas

    Cenário: [Feliz] Manter usuário pendente até definir a senha
        Dado que um usuário recebeu um e-mail com um link para definir sua senha após o cadastro
        Quando o usuário clica no link e é redirecionado para a página de definição de senha
        E o usuário insere uma nova senha válida e confirma a senha
        Então o usuário deve ser capaz de acessar o sistema com suas credenciais

    Cenário: [Triste] Tentar cadastrar usuário com dados inválidos
        Dado que eu acesso a opção de "Gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo JSON contendo os dados de novos usuários do SIGAA
        E os dados estão inválidos no arquivo importado
        Então o sistema deve exibir uma mensagem de erro "Erro: Dados inválidos"
        E o sistema não deve criar solicitações de definição de senha para os usuários 

    Cenário: [Triste] Tentar cadastrar usuário já existente
        Dado que eu acesso a opção de "Gerenciamento" no menu lateral
        Quando eu clico em "Importar Usuários"
        E seleciono um arquivo JSON contendo os dados de novos usuários do SIGAA
        E os dados estão válidos mas correspondem a usuários já existentes no sistema
        Então o sistema deve exibir uma mensagem de aviso "Aviso: Usuário já existe"
        E o sistema não deve criar solicitações de definição de senha para os usuários duplicados



