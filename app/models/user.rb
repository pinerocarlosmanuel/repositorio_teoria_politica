class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :rol, { visitante: 0, editor: 1, admin: 2 }, default: :visitante

  has_many :chat_logs, dependent: :nullify

  def admin?
    rol == "admin"
  end

  def editor?
    rol == "editor"
  end
end
