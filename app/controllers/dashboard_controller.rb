class DashboardController < ApplicationController
  before_action :require_authentication
  before_action :set_site

  def show
    @sites = current_user.sites
    
    if @site
      @total_events = @site.events.humans_only.count
      @page_views = @site.events.humans_only.page_views.count
      @bot_traffic = @site.events.bots_only.count
      @popular_pages = @site.events.humans_only.page_views
                            .group("properties->>'path'")
                            .count
                            .sort_by { |_, count| -count }
                            .first(10)
      @recent_events = @site.events.humans_only.recent.limit(50)
    else
      @total_events = 0
      @page_views = 0
      @bot_traffic = 0
      @popular_pages = []
      @recent_events = []
    end
  end

  def events
    @events = @site.events.humans_only
                   .by_date_range(filter_start_date, filter_end_date)
                   .recent
                   .page(params[:page])
  end
  
  private
  
  def set_site
    @site = if params[:site_id]
      current_user.sites.find(params[:site_id])
    else
      current_user.sites.first
    end
  end
  
  def filter_start_date
    params[:start_date]&.to_date || 7.days.ago
  end
  
  def filter_end_date
    params[:end_date]&.to_date || Date.current
  end
end