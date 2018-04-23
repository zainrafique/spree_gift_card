class Spree::GiftCardTransaction < ActiveRecord::Base
  belongs_to :gift_card
  belongs_to :order, required: false

  validates :amount, :gift_card, presence: true

  scope :authorize, -> { where(action: 'authorize') }
end
