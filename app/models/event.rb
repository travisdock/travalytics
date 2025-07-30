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

  # Localhost filtering scope
  scope :exclude_localhost, -> {
    where.not("page_url LIKE ?", "%localhost%")
         .where.not("page_url LIKE ?", "%127.0.0.1%")
         .where.not("referrer LIKE ?", "%localhost%")
         .where.not("referrer LIKE ?", "%127.0.0.1%")
  }

  # Helper methods for extracting common properties
  def page_path
    properties&.dig("path")
  end

  def page_title
    properties&.dig("title")
  end
end
