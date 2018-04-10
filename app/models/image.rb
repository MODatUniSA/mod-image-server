class Image < ApplicationRecord
  mount_uploader :data, ImageUploader
  mount_uploader :style_data, StyleUploader
end
