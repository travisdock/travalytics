class ApplicationAgent < ActiveAgent::Base
  layout "agent"

  generate_with :openrouter, model: "gpt-4o-mini"
end
