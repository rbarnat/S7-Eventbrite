Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_LOGIN'],
  :secret_key      => ENV['STRIPE_PWD']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key] 