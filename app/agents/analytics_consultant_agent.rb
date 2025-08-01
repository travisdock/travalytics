class AnalyticsConsultantAgent < ApplicationAgent
  before_action :load_site

  def weekly_summary
    @events = Event.where(site_id: @site.id, created_at: 1.week.ago..Time.current).page_views.humans_only.pluck(:page_url, :created_at, :region, :referrer, :properties)
    prompt(message: @events.to_json)
  end

  private

  def load_site
    @site = Site.find(params[:site_id])
  end
end
