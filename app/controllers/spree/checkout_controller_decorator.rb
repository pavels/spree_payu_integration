Spree::CheckoutController.class_eval do

  before_filter :pay_with_payu, only: :update

  private

  def pay_with_payu
    return unless params[:state] == 'payment'

    pm_id = params[:order][:payments_attributes].first[:payment_method_id]
    payment_method = Spree::PaymentMethod.find(pm_id)

    if payment_method && payment_method.kind_of?(Spree::PaymentMethod::Payu)
      @timestamp = Time.now.to_i
      @session_id = "#{@order.id}#{@timestamp}"

      @order_amount = (@order.total * 100).to_i
      @order_description = ((first_store = Spree::Store.first) && first_store.name).to_s

      sig_template = [SpreePayuIntegration::Configuration.merchant_pos_id, 
                      @session_id, 
                      SpreePayuIntegration::Configuration.pos_auth_key, 
                      @order_amount,
                      @order_description,
                      @order.number,
                      @order.bill_address.firstname,
                      @order.bill_address.lastname,
                      @order.email,
                      SpreePayuIntegration::Configuration.language,
                      request.remote_ip,
                      @timestamp,
                      SpreePayuIntegration::Configuration.signature_key
                       ]

      @signature = Digest::MD5.hexdigest(sig_template.join(''))

      render "payu/payment_form"
    end

  rescue StandardError => e
    payu_error(e)
  end

  def payu_error(e = nil)
    @order.errors[:base] << "PayU error #{e.try(:message)}"
    render :edit
  end

end
