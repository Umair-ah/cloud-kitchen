class HomesController < ApplicationController

  def home
    @categories = Category.take(4)
    respond_to do |format|
      format.html
      format.json do
        render json: @categories.as_json(
          except: [:created_at, :updated_at],
          methods: [:image_url]
        )
      end 
    end
  end
  
end