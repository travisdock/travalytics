class SitesController < ApplicationController
  before_action :require_authentication
  before_action :set_site, only: [ :show, :edit, :update, :destroy ]

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
    @events = @site.events.order(created_at: :desc).limit(100)

    # Statistics
    @total_events = @site.events.count
    @total_page_views = @site.events.page_views.count

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
