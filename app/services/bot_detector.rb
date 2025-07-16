class BotDetector
  BOT_PATTERNS = [
    /googlebot/i,
    /bingbot/i,
    /slurp/i,           # Yahoo
    /duckduckbot/i,
    /baiduspider/i,
    /yandexbot/i,
    /facebookexternalhit/i,
    /twitterbot/i,
    /linkedinbot/i,
    /whatsapp/i,
    /telegrambot/i,
    /crawler/i,
    /spider/i,
    /bot/i,
    /scraper/i
  ].freeze

  def self.bot?(user_agent)
    return true if user_agent.blank?

    BOT_PATTERNS.any? { |pattern| user_agent.match?(pattern) }
  end
end
