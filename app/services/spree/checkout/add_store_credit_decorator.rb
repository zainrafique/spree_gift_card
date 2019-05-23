Spree::Checkout::AddStoreCredit.class_eval do

  def call(order:, amount: nil)
    @order = order
    return failed unless @order

    remaining_total = amount ? [amount, @order.outstanding_balance].min : @order.outstanding_balance
    remaining_total -= @order.total_applied_gift_card  # Method overrided from Spree to customize the logic

    ApplicationRecord.transaction do
      @order.payments.store_credits.where(state: :checkout).map(&:invalidate!)
      apply_store_credits(remaining_total) if @order.user&.store_credits&.any?
    end

    @order.reload.payments.store_credits.valid.any? ? success(@order) : failure(@order)
  end

end
