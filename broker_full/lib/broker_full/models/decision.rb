class Decision
  OPTIONS = {
      purchase_max: :pm,
      sell_max:     :sm,
      hold:         :h
  }.freeze

  def self.make(analysis, data, account_service, symbol)
    latest_price = data.latest_price(symbol)

    return OPTIONS[:hold] if analysis.trend_unknown?(symbol)

    if account_service.shares_owned?(symbol) && analysis.latest_price_decreased?(symbol) && analysis.trending_negative?(symbol)
      return OPTIONS[:sell_max]
    elsif account_service.can_purchase?(latest_price) && analysis.latest_price_increased?(symbol) && analysis.trending_positive?(symbol)
      return OPTIONS[:purchase_max]
    end

    return OPTIONS[:hold]
  end

  def self.full_info(latest_price, analysis, account_service, symbol)
    puts "                      #{latest_price} @ [CP] #{account_service.can_purchase?(latest_price)} [SO] #{account_service.shares_owned?(symbol)} [TREND] #{analysis.recent_trend(symbol)} [TU] #{analysis.trend_unknown?(symbol)} " +
             "[TP] #{analysis.trending_positive?(symbol)} [PI] #{analysis.latest_price_increased?(symbol)} [TN] #{analysis.trending_negative?(symbol)} [PD] #{analysis.latest_price_decreased?(symbol)} "
  end
end