# app/models/user.rb
class User < ApplicationRecord
  has_secure_password

  enum :perfil, { discente: 0, docente: 1, admin: 2 }

  has_one :discente
  has_one :docente

  validates :login,  presence: true, uniqueness: { case_sensitive: false }
  validates :email,  presence: true, uniqueness: { case_sensitive: false },
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nome,   presence: true
  validates :perfil, presence: true

  def primeiro_acesso?
    primeiro_acesso
  end

  def perfil_discente?
    discente?
  end

  def perfil_docente?
    docente?
  end

  def perfil_admin?
    admin?
  end
end
