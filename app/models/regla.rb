class Regla < ApplicationRecord
  has_many :chat_logs, dependent: :nullify

  validates :intent, presence: true, uniqueness: true
  validates :keywords, presence: true

  scope :activas, -> { where(activa: true) }

  def keyword_list
    keywords.to_s.split(";").map(&:strip).reject(&:empty?)
  end
end
