class LineItemsController < ApplicationController
  before_action :get_line_item_by_params_id, only: %i[remove_from_cart update_quantity]

  def add_to_cart
    product_title = params[:product_title]
    product = Product.find_by(title: product_title)

    line_item = @current_cart.line_items.find_by(product_id: product.id)

    if line_item
      flash.now[:notice] = "Item is already in cart"
    else
      if product.quantity > 0
        line_item = LineItem.new
        line_item.product = product
        line_item.cart = @current_cart
        line_item.user = @current_user if current_user
        line_item.quantity = 1
        line_item.save!
      end
    end
  end

  def remove_from_cart
    @line_item.destroy
    redirect_to cart_path(@current_cart)
  end

  def update_quantity
    subtract_type = params[:subtract]
    addition_type = params[:addition]

    if subtract_type
      @line_item.quantity -= 1
      if @line_item.quantity == 0
        @line_item.destroy
      else
        @line_item.save!
      end

    elsif addition_type
      if @line_item.product.quantity > @line_item.quantity
        @line_item.quantity += 1
        @line_item.save!
      end
    end
  end

  private

  def get_line_item_by_params_id
    @line_item_id = params[:line_item_id]
    @line_item = @current_cart.line_items.find_by(id: @line_item_id)
  end

end