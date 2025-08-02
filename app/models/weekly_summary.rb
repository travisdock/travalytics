class WeeklySummary < ApplicationRecord
  belongs_to :site

  validates :content, presence: true
  validates :generated_at, presence: true

  scope :recent, -> { order(generated_at: :desc) }
end
