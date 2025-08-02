class AnalyticsConsultantAgent < ApplicationAgent
  before_action :load_site

  def weekly_summary
    events = Event.where(site_id: @site.id, created_at: 1.week.ago..Time.current).page_views.humans_only
    stats = {
      total_page_views: events.count,
      top_pages: events.group(:page_url).count.sort_by { |_, count| -count }.first(10),
      countries: events.group(:country).count.sort_by { |_, count| -count },
      cities: events.group(:city).count.sort_by { |_, count| -count }.first(10),
      regions: events.group(:region).count.sort_by { |_, count| -count }.first(10),
      referrers: events.where.not(referrer: [ nil, "" ]).group(:referrer).count.sort_by { |_, count| -count }.first(10),
      daily_views: events.group("DATE(created_at)").count,
      unique_countries: events.distinct.count(:country),
      unique_pages: events.distinct.count(:page_url)
    }
    events_select = events.select(:page_url, :created_at, :country, :city, :region, :referrer).to_json

    external_events = ExternalEvent.where(user_id: @site.user_id, created_at: 1.week.ago..Time.current).select(:event_type, :title, :description, :event_date, :url).to_json

    message = {
      stats: stats,
      web_events: JSON.parse(events_select),
      external_events: JSON.parse(external_events)
    }
    prompt(message: message.to_json)
  end

  private

  def load_site
    @site = Site.find(params[:site_id])
  end
end
