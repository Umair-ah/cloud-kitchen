class Product < ApplicationRecord
  validates :title, uniqueness: true

  belongs_to :category
  has_many_attached :images

  def first_image_url
    if images.attached?
      Rails.application.routes.url_helpers.rails_blob_url(images.first, only_path: true)
    else
      nil
    end
  end

  def images_url
    if images.attached?
      images.map do |img|
        Rails.application.routes.url_helpers.rails_blob_url(img, host: "62d1-103-188-18-21.ngrok-free.app", protocol: 'https')
      end
    else
      []
    end
  end
  
end
