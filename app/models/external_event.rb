class ExternalEvent < ApplicationRecord
  belongs_to :user

  validates :event_type, presence: true
  validates :title, presence: true
  validates :event_date, presence: true

  scope :by_date_range, ->(start_date, end_date) { where(event_date: start_date..end_date) }
  scope :by_event_type, ->(type) { where(event_type: type) }
  scope :recent, -> { order(event_date: :desc) }

  EVENT_TYPES = %w[
    tweet
    blog_post
    newsletter
    campaign
    product_launch
    press_release
    conference
    webinar
    podcast
    video
    other
  ].freeze

  def self.event_types_for_select
    EVENT_TYPES.map { |type| [ type.humanize, type ] }
  end
end
