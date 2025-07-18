module ApplicationHelper
  def format_datetime(datetime, timezone = nil)
    return "-" if datetime.nil?
    timezone ||= current_user&.time_zone || "UTC"
    datetime.in_time_zone(timezone).strftime("%b %d, %Y %l:%M %p %Z")
  end

  def format_date(date, timezone = nil)
    return "-" if date.nil?
    timezone ||= current_user&.time_zone || "UTC"
    date.in_time_zone(timezone).strftime("%B %d, %Y")
  end
end
