class CartsController < ApplicationController
  def show; end

  def checkout
    @order = Razorpay::Order.create(amount: @current_cart.subtotal.to_i * 100, currency: 'INR')
  end

  def order

    order = Order.new
    # fix this after otp login
    order.full_name = params[:full_name]
    order.phone_number = params[:phone_number]
    order.shipping_address = params[:shipping_address]
    
    order.razor_order_id = params[:order_id]
    order.razor_payment_id = params[:payment_id]
    order.razor_signature = params[:signature]
    
    
    
    @current_cart.line_items.each do |line_item|
      line_item.purchased_price = line_item.product.price
      order.line_items << line_item
    end
    
    order.total_amount = @current_cart.subtotal
    
    if order.save!
      
      @current_cart.destroy
      order.line_items.each do |line_item|
        product = line_item.product
        product.decrement!(:quantity, line_item.quantity)
      end
      render json: { message: "Order placed successfully!", order_id: order.id }, status: :ok
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
    
    payment = Razorpay::Payment.fetch(params[:payment_id])
    if payment.status == 'captured'
      order.paid!
      order.pending!
    else
      order.failed!
    end
  end
  
  

  def success
    @order = Order.find(params[:order_id]) if params[:order_id]
  end

  def failure
    if params[:order_id]
      @razor_order = Razorpay::Order.fetch(params[:order_id]) 
    else
      redirect_to root_path
    end
    
  end

end