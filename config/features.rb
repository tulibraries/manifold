# frozen_string_literal: true

Flipflop.configure do
  strategy :cookie
  strategy :active_record
  strategy :default

  feature :cloudflare_turnstile,
    default: false,
    description: "Enable Cloudflare Turnstile CAPTCHA on public-facing forms"
end
