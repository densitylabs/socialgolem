if Rails.env.development?
  ActionCable.server.config.disable_request_forgery_protection = true
end

# if Rails.env.staging?
#   Rails.application.config.action_cable.allowed_request_origins = [<staging_url>]
# end
