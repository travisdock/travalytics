class EventTracker
  def initialize(request: nil, site:)
    @request = request
    @site = site
  end

  def track(event_name, properties = {})
    # Check if this is from my IP
    ip_address = @request&.remote_ip
    my_ip = Rails.application.credentials.dig(:my_ip)

    if my_ip.present? && ip_address.present?
      # Compare the first 3 octets (since we anonymize the last octet)
      my_ip_prefix = my_ip.split(".")[0..2].join(".")
      request_ip_prefix = ip_address.split(".")[0..2].join(".")

      if my_ip_prefix == request_ip_prefix
        # Silently skip tracking for my IP
        return OpenStruct.new(id: SecureRandom.uuid)
      end
    end

    # Enrich properties with request data if available
    enriched_properties = properties.merge(extract_request_data)

    # Get geo data
    anonymized_ip = anonymize_ip(ip_address)
    geo_data = GeoIpService.lookup(ip_address)

    Event.create!(
      site: @site,
      event_name: event_name,
      properties: enriched_properties,
      page_url: properties[:url] || properties["url"],
      referrer: properties[:referrer] || properties["referrer"] || @request&.referrer,
      user_agent: @request&.user_agent,
      ip_address: anonymized_ip,
      is_bot: BotDetector.bot?(@request&.user_agent),
      country: geo_data[:country],
      city: geo_data[:city],
      region: geo_data[:region]
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
