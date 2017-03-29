Spree::Admin::PaymentsController.class_eval do
  create.before :build_gift_card_payment

  def build_gift_card_payment
    if payment_via_gift_card?
      if gift_card.present?
        @order.payments.gift_cards.checkout.map(&:invalidate!)
        @payment = @order.payments.build
        @payment.source = gift_card
        @payment.amount = [gift_card.amount_remaining, @order.send(:outstanding_balance_after_applied_store_credit)].min
        @payment.payment_method = gift_card_payment_method
      end
    end
  end

  def gift_card_payment_method
    @gift_card_payment_method ||= Spree::PaymentMethod.gift_card.available.first
  end

  def payment_via_gift_card?
    Spree::PaymentMethod.active.find_by(id: params[:payment][:payment_method_id]).eql? gift_card_payment_method
  end

  def gift_card
    @gift_card ||= Spree::GiftCard.find_by(code: gift_card_code)
  end

  def gift_card_code
    @gift_card_code  ||= (params[:payment_source][params[:payment][:payment_method_id]])[:code]
  end
end
