module ApplicationHelper
  def format_datetime(datetime)
    return "-" if datetime.nil?
    # Convert to the current timezone
    datetime.in_time_zone.strftime("%b %d, %Y %l:%M %p %Z")
  end

  def format_date(date)
    return "-" if date.nil?
    # Convert to the current timezone
    date.in_time_zone.strftime("%B %d, %Y")
  end
end
