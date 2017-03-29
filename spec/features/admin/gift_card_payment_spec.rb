require 'spec_helper'

feature "Admin GiftCard Payment", js: true do

  stub_authorization!
  let!(:order) { create(:order_with_line_items) }
  let!(:payment_method) { create(:gift_card_payment_method) }
  let!(:gift_card) { create(:gift_card, email: order.email) }
  let!(:store_credit_payment_method) { create(:store_credit_payment_method) }
  let!(:outstanding_balance_after_store_credit) { 10 }

  context 'gift card w/o order storecredit applied' do
    before do
      create(:credit_card_payment_method)
      @amount = [order.total.to_f, gift_card.current_value.to_f].min
      visit spree.new_admin_order_payment_path(order)
      choose("payment_payment_method_id_#{ payment_method.id }")
      fill_in("gift_code_#{ payment_method.id }", with: gift_card.code)
      click_button 'Continue'
    end

    it 'creating payment by gift_card' do
      expect(page).to have_content('Payment has been successfully created!')
    end

    it 'creating payment by gift_card' do
      expect(find('#payments tr:last-child td.amount')).to have_content(@amount)
    end

    it 'creating payment by gift_card' do
      expect(find('#payments tbody tr:last-child')).to have_content(payment_method.name)
    end
  end

  context 'when order has store_credit payment' do

    before do
      create(:store_credit_payment, order: order, amount: order.total - outstanding_balance_after_store_credit)
      @amount = [order.total.to_f, gift_card.current_value.to_f].min
      visit spree.new_admin_order_payment_path(order)
      choose("payment_payment_method_id_#{ payment_method.id }")
      fill_in("gift_code_#{ payment_method.id }", with: gift_card.code)
      click_button 'Continue'
    end

    it 'expect gift card payment amount to eq outstanding balance after applied storecredit' do
      expect(find('#payments tbody tr:last-child td.amount')).to have_content(outstanding_balance_after_store_credit)
    end
  end
end
