require 'spec_helper'

describe 'Order' do
  describe '#add_gift_card_payments' do
    let(:order_total) { 500.00 }
    let(:gift_card) { create(:gift_card) }
    let(:gift_card_code) { "gc123" }

    before { create(:gift_card_payment_method) }

    subject { order.add_gift_card_payments(gift_card) }

    context 'there is no gift card' do
      let(:gift_card) { nil }
      let(:order) { create(:order, total: order_total) }

      before do
        order.update_column(:total, order_total)
        subject
        order.reload
      end

      it 'does not create a gift card payment' do
        expect(order.payments.count).to eq 0
      end
    end

    context 'gift card has sufficient amount to pay for the entire order' do
      let(:variant) { create(:variant, price: order_total) }
      let(:gift_card) { create(:gift_card, code: gift_card_code, variant: variant) }
      let(:order) { create(:order, total: order_total) }

      before do
        gift_card
        subject
        order.reload
      end

      it 'creates a single payment' do
        expect(order.payments.count).to eq 1
      end

      it 'creates a gift_card payment' do
        expect(order.payments.first).to be_gift_card
      end

      it 'creates a payment for the full amount' do
        expect(order.payments.first.amount).to eq order_total
      end
    end

    context 'the available store credit is not enough to pay for the entire order' do
      let(:expected_cc_total) { 100.0 }
      let(:gift_card_total) { order_total - expected_cc_total }
      let(:variant) { create(:variant, price: gift_card_total) }
      let(:gift_card) { create(:gift_card, code: gift_card_code, variant: variant) }
      let(:order) { create(:order, total: order_total) }

      before do
        order.update_column(:total, order_total)
        gift_card
        subject
        order.reload
      end

      it 'creates a single payment' do
        expect(order.payments.count).to eq 1
      end

      it 'creates a gift_card payment' do
        expect(order.payments.first).to be_gift_card
      end

      it 'creates a payment for the available amount' do
        expect(order.payments.first.amount).to eq gift_card_total
      end
    end
  end

  describe '#total_applied_gift_card' do
    context 'with valid payments' do
      let(:order) { payment.order }
      let!(:payment) { create(:gift_card_payment) }
      let!(:second_payment) { create(:gift_card_payment, order: order) }

      subject { order }

      it 'returns the sum of the payment amounts' do
        expect(subject.total_applied_gift_card).to eq (payment.amount + second_payment.amount)
      end
    end

    context 'without valid payments' do
      let(:order) { create(:order) }

      subject { order }

      it 'returns 0' do
        expect(subject.total_applied_gift_card).to be_zero
      end
    end
  end

  describe '#using_gift_card?' do
    subject { create(:order) }

    context 'order has gift card payment' do
      before { allow(subject).to receive(:total_applied_gift_card).and_return(10.0) }
      it { expect(subject.using_gift_card?).to be true }
    end

    context 'order has no gift card payments' do
      before { allow(subject).to receive(:total_applied_gift_card).and_return(0.0) }
      it { expect(subject.using_gift_card?).to be false }
    end
  end

  describe '#display_total_applied_gift_card' do
    let(:total_applied_gift_card) { 10.00 }

    subject { create(:order) }

    before do
      allow(subject).to receive(:total_applied_gift_card).and_return(total_applied_gift_card)
    end

    it 'returns a money instance' do
      expect(subject.display_total_applied_gift_card).to be_a(Spree::Money)
    end

    it 'returns a negative amount' do
      expect(subject.display_total_applied_gift_card.money.cents).to eq (total_applied_gift_card * -100.0)
    end
  end

  describe '#total_after_gift_card' do
    context 'with valid payments' do
      let(:order) { payment.order }
      let!(:payment) { create(:gift_card_payment) }
      let!(:second_payment) { create(:gift_card_payment, order: order) }

      subject { order }

      it 'returns the difference of order total and sum of the payment amounts' do
        expect(subject.total_after_gift_card).to eq(order.total - (payment.amount + second_payment.amount))
      end
    end

    context 'without valid payments' do
      let(:order) { create(:order) }

      subject { order }

      it 'returns order total' do
        expect(subject.total_after_gift_card).to eq(order.total)
      end
    end
  end

end