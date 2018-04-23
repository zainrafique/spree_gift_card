Spree::LineItem.class_eval do
  has_one :gift_card, dependent: :destroy

  Spree::LineItem::MAXIMUM_GIFT_CARD_LIMIT = 1

  with_options if: :is_gift_card? do
    validates :gift_card, presence: true
    validates :quantity,  numericality: { less_than_or_equal_to: Spree::LineItem::MAXIMUM_GIFT_CARD_LIMIT }, allow_nil: true
  end

  delegate :is_gift_card?, to: :product

end
