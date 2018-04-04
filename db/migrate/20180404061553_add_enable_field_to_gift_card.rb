class AddEnableFieldToGiftCard < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :enabled, :boolean, default: false
  end
end
