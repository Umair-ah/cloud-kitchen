class HomesController < ApplicationController

  def home
    @categories = Category.take(4)
    @products = Product.order(updated_at: :desc).limit(4)
    respond_to do |format|
      format.html
      format.json do
        render json:{
          category: @categories.as_json(
              except: [:created_at, :updated_at],
              methods: [:image_url]
            ),
            products: @products.as_json(
              except: [:created_at, :updated_at],
              methods: [:images_url]
            )
        }
      end 
    end


  end
  

end