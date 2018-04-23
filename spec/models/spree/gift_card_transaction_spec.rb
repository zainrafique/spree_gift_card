require 'spec_helper'

describe Spree::GiftCardTransaction do
  let(:gift_card_authorize_transaction) { FactoryGirl.create(:gift_card_transaction) }
  let(:gift_card_capture_transaction) { FactoryGirl.create(:gift_card_capture_transaction) }

  it { is_expected.to belong_to(:gift_card) }
  it { is_expected.to belong_to(:order) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:gift_card) }

  describe 'scope' do
    describe 'authorize' do
      it 'is expected to include gift card authorize transactions' do
        expect(Spree::GiftCardTransaction.authorize).to include(gift_card_authorize_transaction)
      end

      it 'is expect to not include gift card capture transactions' do
        expect(Spree::GiftCardTransaction.authorize).not_to include(gift_card_capture_transaction)
      end
    end
  end
end
