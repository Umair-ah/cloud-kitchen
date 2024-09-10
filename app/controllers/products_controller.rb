class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :set_category

  # GET /products/:title or /products/:title.json
  def show
    respond_to do |format|
      format.html
      format.json do
        render json: @product.as_json(except: [:created_at, :updated_at], methods: [:images_url])
        
      end
    end
  end

  # GET /products/new
  def new
    @product = @category.products.build
  end

  # GET /products/:title/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = @category.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to root_path, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/:title or /products/:title.json
  def update
    respond_to do |format|
      if @product.update(product_params.reject{ |k| k["images"] })
        if product_params["images"]
          product_params["images"].each do |image|
            @product.images.attach(image)
          end
        end
        format.html { redirect_to root_path, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/:title or /products/:title.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_category
      @category = Category.find_by!(title: params[:category_title])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by!(title: params[:title])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :quantity, :price, :ingredients, :category_id, images: [])
    end
end
