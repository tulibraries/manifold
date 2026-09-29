# frozen_string_literal: true

Flipflop.configure do
  # No cookie strategy: an unsigned client cookie would let any visitor
  # switch cloudflare_turnstile off for their own requests.
  strategy :active_record
  strategy :default

  feature :cloudflare_turnstile,
    default: false,
    description: "Enable Cloudflare Turnstile CAPTCHA on public-facing forms"
end
