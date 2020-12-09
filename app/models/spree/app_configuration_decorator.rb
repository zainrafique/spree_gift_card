Spree::AppConfiguration.class_eval do
  preference :allow_gift_card_redeem, :boolean, default: true
  preference :allow_gift_card_partial_payments, :boolean, default: false
end
