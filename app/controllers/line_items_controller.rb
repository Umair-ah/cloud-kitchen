class LineItemsController < ApplicationController
  before_action :get_line_item_by_params_id, only: %i[remove_from_cart update_quantity]
  #skip_before_action :verify_authenticity_token, only: [:add_to_cart, :remove_from_cart]
  rescue_from StandardError, with: :handle_standard_error

  def add_to_cart
    product_title = params[:product_title]
    product = Product.find_by(title: product_title)
  
    line_item = @current_cart.line_items.find_by(product_id: product.id)
  
    respond_to do |format|
      if line_item
        format.html {
          redirect_to cart_path(@current_cart), notice: "Item Already in cart"
        }
        format.json {
          render json: { message: "Item Already in cart." }, status: :ok
        }
      else
        if product.quantity > 0
          line_item = LineItem.new
          line_item.product = product
          line_item.cart = @current_cart
          line_item.user = @current_user if current_user
          line_item.quantity = 1
          line_item.save!
        end
  
        format.turbo_stream {
          render turbo_stream:
          [
            turbo_stream.update(
              "add_to_cart#{product.title}",
              partial: "shared/add_to_cart_rep",
              locals: { line_item: line_item }
            ),
  
            turbo_stream.update(
              "cart#{@current_cart.id}",
              partial: "shared/cart_size"
            ),
  
            turbo_stream.update(
              "products_#{product.id}",
              partial: "shared/add_to_cart_rep",
              locals: { line_item: line_item }
            ),
  
            turbo_stream.update(
              "line_item#{line_item.id}",
              partial: "shared/line_item_quantity",
              locals: { line_item: line_item }
            )
          ]
        }
  
        format.json {
          render json: {
            line_item: line_item.as_json(
              include: { product: { only: [:title, :price] } },
              only: [:id, :quantity]
            ),
            message: "Item added to cart."
          }, status: :created
        }
      end
    end
  end
  

  def remove_from_cart
    if @line_item.destroy
      respond_to do |format|
        format.html { redirect_to cart_path(@current_cart) }
        format.json { render json: { message: "Item Removed From Cart." }, status: :ok }
      end
    end
  end

  def update_quantity
    subtract_type = params[:subtract]
    addition_type = params[:addition]

    respond_to do |format|
      if subtract_type
        @line_item.quantity -= 1
        if @line_item.quantity == 0
          @line_item.destroy
          format.turbo_stream {
            render turbo_stream:
            [
              turbo_stream.update(
                "add_to_cart#{@line_item.product.title}",
                partial: "shared/add_to_cart_product_page",
                locals: {product: @line_item.product}
              ),

              turbo_stream.update(
                "cart#{@current_cart.id}",
                partial: "shared/cart_size",
              ),

              turbo_stream.update(
                "cart_page_#{@current_cart.id}",
                partial: "shared/cart_page",
              ),

              turbo_stream.update(
                "products_#{@line_item.product.id}",
                partial: "shared/add_to_cart_products_index",
                locals: {product: @line_item.product}
              )
            ]
          }
        else
          @line_item.save!
        end

      elsif addition_type
        if @line_item.product.quantity > @line_item.quantity
          @line_item.quantity += 1
          @line_item.save!
        end
      end

      format.turbo_stream {
        render turbo_stream:
        [
          turbo_stream.update(
            "line_item#{@line_item.id}",
            partial: "shared/line_item_quantity",
            locals: {line_item: @line_item}
          ),

          turbo_stream.update(
            "cart#{@current_cart.id}",
            partial: "shared/cart_size",
          ),

          turbo_stream.update(
            "cart_page_#{@current_cart.id}",
            partial: "shared/cart_page",
          )
        ]
      }
    end
    rescue StandardError => e
      redirect_to request.referer || root_path
  end

  private

  def get_line_item_by_params_id
    @line_item_id = params[:line_item_id]
    @line_item = @current_cart.line_items.find_by(id: @line_item_id)
  end

  def handle_standard_error(exception)
    logger.error "Error in LineItemsController: #{exception.message}"
    redirect_to root_path, alert: "an error has occured, please try again later!"
  end

end