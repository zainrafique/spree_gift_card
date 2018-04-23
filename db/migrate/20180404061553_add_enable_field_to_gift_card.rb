class AddEnableFieldToGiftCard < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_gift_cards, :enabled, :boolean, default: false
  end
end
