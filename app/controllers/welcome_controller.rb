class WelcomeController < ApplicationController

  def index
    @images = Image.where(moderate: false).reverse
  end

  def update_slideshow
    logger.info "Updating slideshow."
    # Save a random 30 moderated images to a slideshow directory.
    @images = ApplicationRecord::Image.where(moderate: false).order("RANDOM()").limit(30)
    # Remove all previous images
    rails_root_path = Rails.root.join('public/slideshow/').to_s
    Dir.glob(rails_root_path + '*.png') do |image|
      logger.info image
      File.delete(image)
    end
    # Now save newly moderated ones
    @images.each do |image|
      image_save_path = rails_root_path + image.id.to_s + File.extname(image.data.url)
      image_path = Rails.root.join('public').to_s + image.data.url

      # Overlay the date a visitor drew their pain
      # "The pain of MOD. visitor #{id}"
      # https://gist.github.com/Eric-Guo/a30e9bbe2bfeabf9c9597a192aec9d0a
      text_overlay_image = MiniMagick::Image.open(image_path)
      text_overlay_image.combine_options do |combine|
        combine.font ENV["image_text_overlay_font_path"]
        combine.pointsize 38
        text_string = "The pain of visitor #{image.id}, #{image.created_at.strftime("%B #{image.created_at.day.ordinalize}")}"
        combine.draw "text 0,0 #{"'" + text_string + "'"}"
        combine.gravity "South"
        combine.fill 'white'
      end
      # Use this to overlay an image or logo
      # outimage = image.composite(MiniMagick::Image.open(logo_image_here)) do |c|
      #   c.compose 'Over'
      #   c.geometry '+246+90'
      # end

      logger.info "Saving slideshow image: " + image_save_path
      text_overlay_image.write(image_save_path)
    end
    redirect_to images_path, notice: 'Slideshow was updated successfully.'
  end

  def reboot_server
    # TODO: Work out why this doesn't work.
    # system "sudo /sbin/reboot"
    redirect_to images_path, notice: 'Rebooting...'
  end
end
