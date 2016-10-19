Spree::Order.class_eval do

  include Spree::Order::GiftCard

  private

  def update_params_payment_source
    if @updating_params[:payment_source].present?
      source_params = @updating_params.
                      delete(:payment_source)[@updating_params[:order][:payments_attributes].
                                              first[:payment_method_id].to_s]

      if source_params
        @updating_params[:order][:payments_attributes].first[:source_attributes] = source_params
      end
    end

    if @updating_params[:order] && (@updating_params[:order][:payments_attributes] ||
                                    @updating_params[:order][:existing_card])
      @updating_params[:order][:payments_attributes] ||= [{}]
      @updating_params[:order][:payments_attributes].first[:amount] = total_after_gift_card
    end
  end
end
