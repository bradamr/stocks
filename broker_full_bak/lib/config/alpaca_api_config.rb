Alpaca::Trade::Api.configure do |config|
  config.endpoint = 'https://api.alpaca.markets' unless ENV['ALPACA_LIVE'].nil?
  config.key_id = ENV['ALPACA_API_KEY']
  config.key_secret = ENV['ALPACA_API_SECRET']
end