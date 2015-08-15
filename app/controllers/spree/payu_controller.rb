module Spree
  class PayuController < Spree::BaseController
    protect_from_forgery except: [:notify, :continue]

    def notify

      resp_doc = SpreePayuIntegration::Api.load_transaction params[:session_id]

      status = resp_doc.at_xpath('//response/trans/status').content.to_i
      order_number = resp_doc.at_xpath('//response/trans/order_id').content

      order = Spree::Order.friendly.find(order_number)
      payment = order.payments.last

      case status
        when 2, 7
          payment.failure! if payment
        when 99          
          payment_success(order)
          payment.complete!
      end

      if payment
        payment.response_code = params[:session_id]
        payment.save
      end
      
      render text: "OK"
    end

    def positive
      order = Spree::Order.friendly.find(params["order_id"])
      payment_success(order)

      redirect_to order_path(order)
    end

    def negative
      redirect_to checkout_path
    end


    def payment_success(order)

      return if order.payments.count > 0

      payment_method = Spree::PaymentMethod.where(type: "Spree::PaymentMethod::Payu").first

      payment = order.payments.build(
        payment_method_id: payment_method.id,
        amount: order.total,
        state: 'checkout'
      )

      payment.save
      order.next

      payment.pend!

    end


  end
end