# language: pt

Feature: Responder formulário
  Como discente
  Quero preencher e enviar os formulários de avaliação
  A fim de registrar meu feedback sobre as disciplinas e docentes

  Cenário: [Feliz] Responder um formulário com todos os dados válidos
    Dado que eu estou na página de resposta do formulário da turma "CIC0097 - BANCOS DE DADOS"
    Quando eu preencho todas as perguntas obrigatórias com o valor "5"
    E eu envio o formulário
    Então o sistema deve exibir a mensagem "Avaliação enviada com sucesso"
    E o formulário deve sumir da minha lista de pendentes

  Cenário: [Triste] Tentar enviar um formulário com campos obrigatórios vazios
    Dado que eu estou na página de resposta do formulário da turma "CIC0105 - ENGENHARIA DE SOFTWARE"
    Quando eu deixo a pergunta "Avaliação do Docente" em branco
    E eu tento enviar o formulário
    Então o sistema deve exibir a mensagem de erro "Todos os campos obrigatórios devem ser preenchidos"
    E o formulário não deve ser computado

  Cenário: [Triste] Tentar preencher o formulário com notas fora do intervalo permitido
    Dado que eu estou na página de resposta do formulário da turma "CIC0202 - PROGRAMAÇÃO CONCORRENTE"
    Quando eu insiro o valor "6" em uma das perguntas de nota
    E eu tento enviar o formulário
