class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
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

  # GET /categories/:title or /categories/:title.json
  def show
    respond_to do |format|
      format.html # Renders the HTML template for show
      format.json do
        render json: {
          category: {
            id: @category.id,
            title: @category.title,
            image_url: url_for(@category.image),
            products: @category.products.as_json(
              except: [:created_at, :updated_at],
              methods: [:images_url]
            ),
           
          }
        }
      end
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/:title/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to category_url(@category.title), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/:title or /categories/:title.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to root_path, notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/:title or /categories/:title.json
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find_by(title: params[:title])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:title, :image)
    end
end
