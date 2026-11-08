class ChatLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :regla, optional: true

  validates :pregunta, presence: true
end
