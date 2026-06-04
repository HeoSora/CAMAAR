class User < ApplicationRecord
  has_secure_password validations: false

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true, uniqueness: true
  validates :perfil, presence: true

  validates :password,
            length: { minimum: 6 },
            confirmation: true,
            if: -> { password.present? || password_confirmation.present? }

  def password_set?
    password_digest.present?
  end
end
