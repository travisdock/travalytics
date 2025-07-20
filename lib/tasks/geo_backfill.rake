namespace :geo do
  desc "Backfill geo location data for existing events"
  task backfill: :environment do
    unless Rails.application.config.maxmind_db_path.present?
      puts "MaxMind database not configured. Set MAXMIND_DB_PATH environment variable."
      exit 1
    end

    # Get all events without geo data but with IP addresses
    events_to_update = Event.where(country: nil)
                           .where.not(ip_address: [ nil, "" ])

    total = events_to_update.count
    puts "Found #{total} events to update with geo data..."

    if total == 0
      puts "No events need geo data backfill."
      exit 0
    end

    updated = 0
    failed = 0

    events_to_update.find_each.with_index do |event, index|
      begin
        # Reconstruct the original IP from the anonymized version
        # Since we zero out the last octet, we'll use .1 for the lookup
        # This will still give us accurate country/city/region data
        lookup_ip = event.ip_address.gsub(/\.0$/, ".1")

        geo_data = GeoIpService.lookup(lookup_ip)

        if geo_data.any?
          event.update!(
            country: geo_data[:country],
            city: geo_data[:city],
            region: geo_data[:region]
          )
          updated += 1
        else
          failed += 1
        end

        # Progress indicator
        if (index + 1) % 100 == 0 || (index + 1) == total
          print "\rProgress: #{index + 1}/#{total} (#{updated} updated, #{failed} failed)"
        end
      rescue => e
        failed += 1
        puts "\nError processing event #{event.id}: #{e.message}"
      end
    end

    puts "\n\nBackfill complete!"
    puts "Successfully updated: #{updated} events"
    puts "Failed/Skipped: #{failed} events"
  end

  desc "Show geo data statistics"
  task stats: :environment do
    total_events = Event.count
    events_with_geo = Event.where.not(country: nil).count
    events_without_geo = total_events - events_with_geo

    puts "=== Geo Data Statistics ==="
    puts "Total events: #{total_events}"
    puts "Events with geo data: #{events_with_geo} (#{(events_with_geo.to_f / total_events * 100).round(1)}%)"
    puts "Events without geo data: #{events_without_geo}"

    if events_with_geo > 0
      puts "\n=== Top 10 Countries ==="
      Event.where.not(country: nil)
           .group(:country)
           .count
           .sort_by { |_, count| -count }
           .first(10)
           .each_with_index do |(country, count), index|
        puts "#{index + 1}. #{country}: #{count} events"
      end
    end
  end
end
