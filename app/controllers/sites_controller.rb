class SitesController < ApplicationController
  before_action :require_authentication
  before_action :set_site, only: [ :show, :edit, :update, :destroy, :page_durations ]

  def index
    @sites = current_user.sites
  end

  def new
    @site = current_user.sites.build
  end

  def create
    @site = current_user.sites.build(site_params)

    if @site.save
      redirect_to @site, notice: "Site created successfully"
    else
      render :new
    end
  end

  def show
    @events = @site.events
      .where(event_name: "page_view")
      .order(created_at: :desc)
      .limit(100)

    # Statistics
    @total_events = @site.events.count
    @total_page_views = @site.events.page_views.count

    # Page views data for past 10 days
    end_date = Date.current.end_of_day
    start_date = 9.days.ago.beginning_of_day
    @page_views_by_day = @site.events
      .page_views
      .humans_only
      .where(created_at: start_date..end_date)
      .group("DATE(created_at)")
      .count
      .transform_keys { |k| k.to_date }

    # Fill in missing days with 0 views
    (start_date.to_date..end_date.to_date).each do |date|
      @page_views_by_day[date] ||= 0
    end

    # Sort by date and prepare data for chart
    @chart_data = @page_views_by_day.sort_by { |date, _| date }.to_h

    # Top paths (excluding bots)
    # Get paths from properties or extract from URL
    paths_hash = {}
    @site.events
      .where(is_bot: false)
      .where.not(page_url: nil)
      .pluck(:properties, :page_url)
      .each do |properties, page_url|
        path = properties&.dig("path") || begin
          uri = URI.parse(page_url)
          uri.path.presence || "/"
        rescue URI::InvalidURIError => e
          Rails.logger.warn "Invalid URL in event: #{page_url} - #{e.message}"
          "[Invalid URL: #{page_url}]"
        end
        paths_hash[path] = (paths_hash[path] || 0) + 1
      end
    @top_paths = paths_hash.sort_by { |_, count| -count }.first(10)

    # Top referrers (excluding bots and no referrer)
    # Group referrers by domain to avoid duplicates from different paths
    referrers_hash = {}
    @site.events
      .where(is_bot: false)
      .where.not(referrer: [ nil, "" ])
      .pluck(:referrer)
      .each do |referrer|
        domain = begin
          uri = URI.parse(referrer)
          uri.host || referrer
        rescue URI::InvalidURIError => e
          Rails.logger.warn "Invalid referrer URL: #{referrer} - #{e.message}"
          referrer
        end
        referrers_hash[domain] = (referrers_hash[domain] || 0) + 1
      end
    @top_referrers = referrers_hash.sort_by { |_, count| -count }.first(10)

    # Top countries (excluding bots)
    @top_countries = @site.events
      .where(is_bot: false)
      .where.not(country: [ nil, "" ])
      .group(:country)
      .count
      .sort_by { |_, count| -count }
      .first(10)
  end

  def page_durations
    # Get all page_duration events
    duration_events = @site.events
      .where(event_name: "page_duration")
      .where(is_bot: false)
      .where.not(properties: nil)

    # Extract duration data
    durations_by_page = {}
    all_durations = []

    duration_events.find_each do |event|
      duration = event.properties&.dig("duration")
      path = event.properties&.dig("path") || event.page_path || "/"

      next unless duration.present? && duration.is_a?(Numeric) && duration > 0

      # Convert to seconds if duration is in milliseconds
      duration_in_seconds = duration > 1000 ? duration / 1000.0 : duration

      all_durations << duration_in_seconds
      durations_by_page[path] ||= []
      durations_by_page[path] << duration_in_seconds
    end

    # Calculate statistics
    if all_durations.any?
      @total_average_duration = all_durations.sum / all_durations.size.to_f
      @highest_duration = all_durations.max
      @lowest_duration = all_durations.min
      @total_duration_events = all_durations.size
    else
      @total_average_duration = 0
      @highest_duration = 0
      @lowest_duration = 0
      @total_duration_events = 0
    end

    # Calculate per-page statistics
    @page_duration_stats = durations_by_page.map do |path, durations|
      {
        path: path,
        average: durations.sum / durations.size.to_f,
        min: durations.min,
        max: durations.max,
        count: durations.size
      }
    end.sort_by { |stat| -stat[:average] } # Sort by highest average duration first
  end

  def edit
  end

  def update
    if @site.update(site_params)
      redirect_to @site, notice: "Site updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @site.destroy
    redirect_to sites_path, notice: "Site deleted successfully"
  end

  private

  def set_site
    @site = current_user.sites.find(params[:id])
  end

  def site_params
    params.require(:site).permit(:name, :domain)
  end
end
