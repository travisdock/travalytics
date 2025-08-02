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

  def render_markdown(text)
    return "" if text.blank?

    # Simple markdown to HTML conversion
    # Convert headers
    html = text.gsub(/^#### (.+)$/, '<h4>\1</h4>')
               .gsub(/^### (.+)$/, '<h3>\1</h3>')
               .gsub(/^## (.+)$/, '<h2>\1</h2>')
               .gsub(/^# (.+)$/, '<h1>\1</h1>')

    # Convert bold text
    html = html.gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')

    # Convert italic text
    html = html.gsub(/\*(.+?)\*/, '<em>\1</em>')

    # Convert bullet lists (both * and - styles)
    html = html.gsub(/^[\*\-] (.+)$/, '<li>\1</li>')

    # Group consecutive list items into ul tags
    html = html.gsub(/(<li>(?!.*\d+\.).+<\/li>\n?)+/m) { |list| "<ul>#{list}</ul>" }

    # Convert numbered lists
    html = html.gsub(/^\d+\. (.+)$/, '<li class="numbered">\1</li>')
    html = html.gsub(/(<li class="numbered">.+<\/li>\n?)+/m) { |list| "<ol>#{list.gsub(' class="numbered"', '')}</ol>" }

    # Convert line breaks to paragraphs
    paragraphs = html.split("\n\n").map { |p| p.strip }.reject(&:blank?)
    html = paragraphs.map do |p|
      if p.start_with?("<h", "<ul", "<ol")
        p
      else
        "<p>#{p}</p>"
      end
    end.join("\n")

    # Sanitize HTML to prevent XSS
    sanitize(html, tags: %w[h1 h2 h3 h4 h5 h6 p strong em ul ol li br], attributes: {})
  end
end
