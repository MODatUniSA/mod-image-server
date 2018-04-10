class WelcomeController < ApplicationController
  def index
    @images = Image.where(moderate: false).reverse
  end
end
