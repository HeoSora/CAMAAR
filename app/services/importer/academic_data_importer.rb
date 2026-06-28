module Importer
  class AcademicDataImporter
    def self.import!(upload_file)
      start_time = Time.current

      file_path = File.read(upload_file.tempfile.path)
      data_hash = JSON.parse(file_path)



      ActiveRecord::Base.transaction do
          departamento = Departamento.find_or_create_by!(nome: "Ciência da Computação")
        unique_turmas = data_hash.uniq { |t| [ t["code"], t["classCode"], t["semester"] ] }

        turma_objects = unique_turmas.map do |t|
          Turma.new(codigo: t["code"], nome: t["classCode"], semestre: t["semester"], departamento: departamento)
        end
        # duplicação de objetos
        Turma.import turma_objects, on_duplicate_key_ignore: true, validate: false

        turmas_hash = Turma.all.pluck(:codigo, :nome, :semestre, :id).each_with_object({}) do |(codigo, nome, semestre, id), hash|
          hash["#{codigo}-#{nome}-#{semestre}"] = id
        end

        # armazenar os discentes e docentes
        raw_discentes = []
        raw_docentes = []

        data_hash.each do |turma_dados|
          turma_id = turmas_hash["#{turma_dados['code']}-#{turma_dados['classCode']}-#{turma_dados['semester']}"]
          next unless turma_id

          if turma_dados["dicente"].is_a?(Array)
            turma_dados["dicente"].each do |d|
              raw_discentes << d.merge("turma_id" => turma_id)
            end
          end

          if turma_dados["docente"].is_a?(Hash)
            d_user = turma_dados["docente"]
            raw_docentes << d_user.merge("turma_id" => turma_id)
          end
        end


        unique_discentes = raw_discentes.uniq { |d| d["matricula"] }
        unique_docentes = raw_docentes.uniq { |d| d["email"] }

        usuarios_discente_objects = unique_discentes.map do |members|
          Usuario.new(
            login: members["matricula"],
            nome: members["nome"]&.downcase,
            email: members["email"],
            perfil: :discente,
            password: "123456",
            password_confirmation: "123456",
            primeiro_acesso: false
          )
        end
        Usuario.import usuarios_discente_objects, on_duplicate_key_ignore: true, validate: false

        emails_importados = usuarios_discente_objects.map(&:email)
        usuarios_salvos = Usuario.where(email: emails_importados)
        usuarios_por_email = usuarios_salvos.index_by(&:email)

        discente_objects = unique_discentes.filter_map do |members|
          usuario = usuarios_por_email[members["email"]]
          next unless usuario

          Discente.new(
            usuario: usuario,
            matricula: members["matricula"],
            curso: members["curso"]&.downcase
          )
        end
        Discente.import discente_objects, on_duplicate_key_ignore: true, validate: false

        matricula_objects = unique_discentes.filter_map do |members|
          usuario = usuarios_por_email[members["email"]]
          discente = Discente.find_by(usuario: usuario)
          turma_id = members["turma_id"]

          next unless discente && turma_id

          Matricula.new(discente: discente, turma_id: turma_id)
        end
        Matricula.import matricula_objects, on_duplicate_key_ignore: true, validate: false

        usuarios_salvos.each do |usuario|
          UserMailer.primeiro_acesso(usuario).deliver_later
        end

        usuarios_docente_objects = unique_docentes.map do |members|
          Usuario.new(
            login: members["email"],
            nome: members["nome"]&.downcase,
            email: members["email"],
            perfil: :docente,
            password: "123456",
            password_confirmation: "123456",
            primeiro_acesso: false
          )
        end
        Usuario.import usuarios_docente_objects, on_duplicate_key_ignore: true, validate: false

        docentes_por_email = Usuario.where(email: usuarios_docente_objects.map(&:email)).index_by(&:email)

        docente_objects = unique_docentes.filter_map do |members|
          usuario = docentes_por_email[members["email"]]
          next unless usuario

          Docente.new(usuario: usuario, departamento: departamento)
        end
        Docente.import docente_objects, on_duplicate_key_ignore: true, validate: false

        unique_docentes.each do |members|
          usuario = docentes_por_email[members["email"]]
          docente = Docente.find_by(usuario: usuario)
          turma = Turma.find_by(id: members["turma_id"])

          turma&.update!(docente: docente) if docente
        end
      end
      # registro de erros
    rescue StandardError => e
      error = "Erro na transação de importação: #{e.message}"
      Rails.logger.error error
      raise

    elapsed_time = Time.current - start_time
      Rails.logger.info "Tempo total de importação: #{elapsed_time.round(2)} segundos"
      true
    end
  end
end
