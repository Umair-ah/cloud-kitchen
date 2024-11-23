class MobilesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def razorpay_order_id
    @order = Razorpay::Order.create(amount: params[:amount].to_i * 100, currency: 'INR')
    render json: { orderId: @order.id }
  end



end