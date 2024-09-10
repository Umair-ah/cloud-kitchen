class Category < ApplicationRecord
  validates :title, uniqueness: true
  has_one_attached :image
  has_many :products

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    else
      nil
    end
  end

  def images_url
    self.products.each do |product|
      product.images.each do |image|
        image.attached? ? image.map { |img| Rails.application.routes.url_helpers.rails_blob_url(img, only_path: true) } : []
      end
    end
  end
end
