class AddPerformanceFieldsToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :page_path, :string
    add_column :events, :referrer_domain, :string

    # Composite indexes for common query patterns
    add_index :events, [ :site_id, :created_at ]
    add_index :events, [ :site_id, :is_bot, :created_at ]
    add_index :events, [ :site_id, :page_path ]
    add_index :events, [ :site_id, :referrer_domain ]

    # Backfill existing records
    reversible do |dir|
      dir.up do
        Event.find_each do |event|
          page_path = event.properties&.dig("path") || begin
            uri = URI.parse(event.page_url.to_s)
            uri.path.presence || "/"
          rescue URI::InvalidURIError
            "/"
          end

          referrer_domain = begin
            uri = URI.parse(event.referrer.to_s)
            uri.host
          rescue URI::InvalidURIError
            nil
          end

          event.update_columns(page_path: page_path, referrer_domain: referrer_domain)
        end
      end
    end
  end
end
