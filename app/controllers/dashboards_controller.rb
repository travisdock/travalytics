class DashboardsController < ApplicationController
  before_action :require_authentication

  def show
    @sites = current_user.sites

    # Build stats for each site
    @sites_with_stats = @sites.map do |site|
      {
        site: site,
        total_events: site.events.humans_only.exclude_localhost.count,
        page_views: site.events.humans_only.page_views.exclude_localhost.count,
        bot_traffic: site.events.bots_only.exclude_localhost.count,
        popular_pages: site.events.humans_only.page_views.exclude_localhost
                          .group("properties->>'path'")
                          .count
                          .sort_by { |_, count| -count }
                          .first(5) # Show top 5 pages per site
      }
    end
  end

  def events
    @site = current_user.sites.find(params[:site_id])
    @events = @site.events.humans_only
                   .exclude_localhost
                   .by_date_range(filter_start_date, filter_end_date)
                   .recent
  end

  private

  def filter_start_date
    params[:start_date]&.to_date || 7.days.ago
  end

  def filter_end_date
    params[:end_date]&.to_date || Date.current
  end
end
