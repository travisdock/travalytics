class Site < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy
  has_many :weekly_summaries, dependent: :destroy

  validates :name, presence: true
  validates :domain, presence: true, uniqueness: true
  validates :tracking_id, presence: true, uniqueness: true

  before_validation :generate_tracking_id, on: :create

  def create_weekly_summary
    # Using generate_now since background jobs aren't set up yet
    response = AnalyticsConsultantAgent.with(site_id: id).weekly_summary.generate_now

    # Save the generated summary
    weekly_summaries.create!(
      content: response.message.content,
      generated_at: Time.current
    )
  end

  def latest_weekly_summary
    weekly_summaries.recent.first
  end

  private

  def generate_tracking_id
    self.tracking_id ||= SecureRandom.uuid
  end
end
