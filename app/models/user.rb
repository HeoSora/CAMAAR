class User < ApplicationRecord
  has_secure_password

  has_many :templates, dependent: :destroy

  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true, uniqueness: true
  validates :perfil, presence: true
end
