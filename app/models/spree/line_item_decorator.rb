Spree::LineItem.class_eval do

  MAXIMUM_GIFT_CARD_LIMIT = 1

  has_one :gift_card, dependent: :destroy

  validates :gift_card, presence: { if: Proc.new{ |item| item.product.is_gift_card? } }
  validates :quantity,  numericality: { if: Proc.new{ |item| item.product.is_gift_card? }, less_than_or_equal_to: MAXIMUM_GIFT_CARD_LIMIT }

end
