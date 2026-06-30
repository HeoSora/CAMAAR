# 📄 Documentação de Modelos (Models) - CAMAAR

A camada de modelos do CAMAAR está desenhada para gerir três grandes domínios da aplicação: **Autenticação & Perfis**, **Estrutura Académica** e **Motor de Avaliações (Formulários)**.

## 1. Domínio de Autenticação e Utilizadores
Estes modelos gerem quem acede ao sistema e os seus papéis específicos.

* **`User` / `Usuario`:** Representam a base de autenticação do sistema. Guardam as credenciais (email, matrícula, palavra-passe) e o perfil global de acesso. (O modelo `Usuario` atua como suporte à estrutura legada/associativa de dados).
* **`Admin`:** Perfil com privilégios máximos no sistema. Pode gerir dados e departamentos.
* **`Docente`:** Perfil associado a um departamento. Responsável por criar os Modelos de Avaliação (`Templates`).
* **`Discente`:** Perfil do aluno. Relaciona-se com as turmas nas quais está matriculado e responde aos formulários de avaliação.

## 2. Domínio da Estrutura Académica
Modelos que representam o ecossistema da universidade, turmas e matrículas.

* **`Departamento`:** Unidade académica que agrupa Docentes, Turmas e pode ser gerida por um Admin.
* **`Disciplina`:** Representa o catálogo de matérias oferecidas.
* **`Turma`:** Uma instância de uma disciplina num semestre específico. É a esta entidade que os formulários de avaliação são aplicados.
* **`Matricula`:** Tabela de junção (relação N:N) que liga um `Discente` a uma `Turma`, determinando quais formulários o aluno tem o direito de responder.

## 3. Domínio de Avaliações (Templates e Formulários)
Modelos responsáveis pela criação estrutural das avaliações que os docentes preparam.

* **`Template`:** O modelo base de uma avaliação, criado por um Docente. Pode ser reutilizado em diferentes semestres ou turmas.
* **`QuestaoTemplate`:** As perguntas originais que pertencem a um `Template`.
* **`OpcaoQuestao`:** As alternativas disponíveis para as questões de múltipla escolha (se aplicável).
* **`Formulario`:** A instância viva e aplicável de um Template. É gerado quando um modelo de avaliação é vinculado a uma `Turma` específica. Possui prazos (data de abertura e encerramento) e o estado (status).
* **`Questao`:** Cópia independente ou referência direta da pergunta instanciada dentro de um `Formulario` aberto.

## 4. Domínio de Respostas e Submissões
Modelos que lidam com os dados enviados pelos alunos.

* **`EnvioFormulario`:** Registo de submissão que garante que um `Discente` já completou e enviou um determinado `Formulario`. Evita que o mesmo aluno responda duas vezes à mesma avaliação.
* **`Resposta`:** Registo individual que armazena a nota (normalmente de 1 a 5) ou o conteúdo que o aluno submeteu para uma `Questao` específica vinculada ao seu `EnvioFormulario`.