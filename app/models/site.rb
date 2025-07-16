class Site < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :domain, presence: true, uniqueness: true
  validates :tracking_id, presence: true, uniqueness: true

  before_validation :generate_tracking_id, on: :create

  private

  def generate_tracking_id
    self.tracking_id ||= SecureRandom.uuid
  end
end
