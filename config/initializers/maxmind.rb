# MaxMind GeoIP2 Configuration
# 
# To use MaxMind GeoIP2, you need to:
# 1. Download a GeoLite2 or GeoIP2 database from https://www.maxmind.com
# 2. Set the MAXMIND_DB_PATH environment variable to the database file path
#
# For GeoLite2 (free):
# - Register at https://www.maxmind.com/en/geolite2/signup
# - Download GeoLite2-City.mmdb
#
# Example:
# MAXMIND_DB_PATH=/path/to/GeoLite2-City.mmdb

Rails.application.config.maxmind_db_path = ENV.fetch("MAXMIND_DB_PATH", "vendor/maxmind/GeoLite2-City.mmdb")

# Optionally disable geo lookup in development/test
Rails.application.config.enable_geo_lookup = ENV.fetch("ENABLE_GEO_LOOKUP", Rails.env.production?).to_s == "true"