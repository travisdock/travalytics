class GeoIpService
  class << self
    def lookup(ip_address)
      return {} unless enabled? && ip_address.present?
      
      # Try to get location data from MaxMind
      location_data = reader.city(ip_address)
      
      {
        country: location_data.country.name,
        city: location_data.city&.name,
        region: location_data.subdivisions&.first&.name
      }
    rescue => e
      Rails.logger.error "GeoIP lookup failed for #{ip_address}: #{e.message}"
      {}
    end
    
    private
    
    def enabled?
      Rails.application.config.enable_geo_lookup && db_path.present?
    end
    
    def db_path
      Rails.application.config.maxmind_db_path
    end
    
    def reader
      @reader ||= begin
        raise "MaxMind database not found at #{db_path}" unless File.exist?(db_path)
        MaxMind::GeoIP2::Reader.new(database: db_path)
      end
    end
  end
end