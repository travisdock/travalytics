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

    # Convert lists with proper nesting support
    html = convert_lists(html)

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

  private

  def convert_lists(text)
    lines = text.split("\n")
    result = []

    lines.each do |line|
      case line
      when /^(\s*)[\*\-] (.+)$/
        # Handle bullet lists with indentation
        indent = $1.length
        content = $2
        if indent == 0
          result << "<li>#{content}</li>"
        else
          # Nested list item
          result << "#{' ' * indent}<li>#{content}</li>"
        end
      when /^(\s*)(\d+)\. (.+)$/
        # Handle numbered lists with indentation
        indent = $1.length
        content = $3
        if indent == 0
          result << "<li class=\"numbered\">#{content}</li>"
        else
          # Nested numbered list item
          result << "#{' ' * indent}<li class=\"numbered\">#{content}</li>"
        end
      else
        result << line
      end
    end

    html = result.join("\n")

    # Group consecutive list items into ul/ol tags
    # Handle bullet lists
    html = html.gsub(/(<li>(?!\s)(?!.*class="numbered").+<\/li>\n?)+/m) do |list|
      "<ul>#{list}</ul>"
    end

    # Handle nested bullet lists
    html = html.gsub(/(\s+<li>(?!.*class="numbered").+<\/li>\n?)+/m) do |list|
      indent = list[/^\s*/]
      cleaned_list = list.gsub(/^\s+/, "")
      "#{indent}<ul>#{cleaned_list}</ul>"
    end

    # Handle numbered lists by looking for consecutive numbered items
    # Split by double newlines to process each paragraph block separately
    blocks = html.split(/\n\n+/)
    processed_blocks = blocks.map do |block|
      # Check if this block contains numbered list items
      if block.include?('<li class="numbered">')
        # Group consecutive numbered items within this block
        block.gsub(/(<li class="numbered">.+<\/li>\n?)+/m) do |list|
          "<ol>#{list.gsub(' class="numbered"', '')}</ol>"
        end
      else
        block
      end
    end

    html = processed_blocks.join("\n\n")

    # Handle nested numbered lists
    html = html.gsub(/(\s+<li class="numbered">.+<\/li>\n?)+/m) do |list|
      indent = list[/^\s*/]
      cleaned_list = list.gsub(/^\s+/, "").gsub(' class="numbered"', "")
      "#{indent}<ol>#{cleaned_list}</ol>"
    end

    html
  end
end
