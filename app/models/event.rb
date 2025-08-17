class Event < ApplicationRecord
  belongs_to :site

  validates :event_name, presence: true

  scope :by_date_range, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :by_event_name, ->(name) { where(event_name: name) }
  scope :by_page_url, ->(url) { where(page_url: url) }
  scope :by_site, ->(site) { where(site: site) }
  scope :recent, -> { order(created_at: :desc) }

  # Helper scopes for common event types
  scope :page_views, -> { where(event_name: "page_view") }
  scope :clicks, -> { where(event_name: [ "button_click", "link_click" ]) }
  scope :form_submissions, -> { where(event_name: "form_submit") }

  # Bot filtering scopes
  scope :humans_only, -> { where(is_bot: false) }
  scope :bots_only, -> { where(is_bot: true) }

  # Unique visitor scopes
  scope :with_visitor_uuid, -> { where.not(visitor_uuid: nil) }
  scope :by_visitor_uuid, ->(uuid) { where(visitor_uuid: uuid) }

  # Get unique visitors count for a given scope
  def self.unique_visitors_count
    with_visitor_uuid.distinct.count(:visitor_uuid)
  end

  # Get unique visitors for a date range
  def self.unique_visitors_by_date_range(start_date, end_date)
    by_date_range(start_date, end_date).with_visitor_uuid.distinct.pluck(:visitor_uuid)
  end

  # Helper methods for extracting common properties
  def page_path
    properties&.dig("path")
  end

  def page_title
    properties&.dig("title")
  end
end
