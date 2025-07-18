class EventTracker
  def initialize(request: nil, site:)
    @request = request
    @site = site
  end

  def track(event_name, properties = {})
    # Enrich properties with request data if available
    enriched_properties = properties.merge(extract_request_data)

    Event.create!(
      site: @site,
      event_name: event_name,
      properties: enriched_properties,
      page_url: properties[:url] || properties["url"],
      referrer: properties[:referrer] || properties["referrer"] || @request&.referrer,
      user_agent: @request&.user_agent,
      ip_address: anonymize_ip(@request&.remote_ip),
      is_bot: BotDetector.bot?(@request&.user_agent)
    )
  end

  private

  def extract_request_data
    return {} unless @request

    {
      timestamp: Time.current.iso8601,
      user_agent: @request.user_agent,
      referrer: @request.referrer
    }
  end

  def anonymize_ip(ip)
    return nil unless ip
    # Simple IP anonymization - zero out last octet
    ip.split(".")[0..2].join(".") + ".0"
  end
end
