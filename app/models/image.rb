class Image < ApplicationRecord
  mount_uploader :data, ImageUploader
end
