class WelcomeController < ApplicationController
  def index
    @images = Image.where(moderate: false).reverse
  end

  def update_slideshow
    logger.info "Updating slideshow."
    # Save all images to a slideshow directory.
    @images = Image.where(moderate: false).reverse
    # TODO: Remove all previous images, then save new ones.
    @images.each do |image|
      image_save_path = Rails.root.join('public/slideshow/').to_s + image.id.to_s + File.extname(image.data.url)
      image_path = Rails.root.join('public').to_s + image.data.url
      logger.info "Saving slideshow image: " + image_save_path
      File.open(image_save_path, 'w') do |f|
        f.puts File.read(image_path)
      end
    end
    redirect_to images_path, notice: 'Slideshow was updated successfully.'
  end

  def reboot_server
    system "sudo /sbin/reboot"
    redirect_to images_path, notice: 'Rebooting...'
  end
end
