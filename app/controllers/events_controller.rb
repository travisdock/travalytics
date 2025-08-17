class EventsController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token
  before_action :find_site_by_tracking_id
  before_action :validate_origin
  before_action :rate_limit

  def create
    event = EventTracker.new(request: request, site: @site).track(
      event_params[:event_name],
      event_params[:properties] || {},
      visitor_uuid: event_params[:visitor_uuid]
    )

    render json: { status: "success", event_id: event.id }
  rescue => e
    render json: { status: "error", message: e.message }, status: 422
  end

  private

  def event_params
    params.require(:event).permit(:event_name, :visitor_uuid, properties: {})
  end

  def find_site_by_tracking_id
    @site = Site.find_by(tracking_id: params[:tracking_id])
    render json: { status: "error", message: "Invalid tracking ID" }, status: 401 unless @site
  end

  def validate_origin
    origin = request.headers["Origin"] || request.headers["Referer"]
    return if origin.blank?

    origin_domain = URI.parse(origin).host
    # Allow localhost for testing
    return if origin_domain == "localhost" || origin_domain == "127.0.0.1"

    unless origin_domain == @site.domain || origin_domain.end_with?(".#{@site.domain}")
      render json: { status: "error", message: "Origin not allowed" }, status: 403
    end
  end

  def rate_limit
    # TODO: Future enhancement - implement rate limiting per site
    # This will help prevent abuse and ensure fair usage across sites
  end
end
