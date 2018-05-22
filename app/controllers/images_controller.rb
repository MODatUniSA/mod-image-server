class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # TOFIX: turn this back on and setup API key if opening this up to the big bad internets.
  # Test upload: curl -i -F image[data]=@/file.jpg http://localhost:3000/images
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /images
  # GET /images.json
  def index
    @image_count = Image.count
    if ActionController::Base.helpers.sanitize(params[:accepted]) == "true"
      # Just show the accepted images
      @images = Image.where(moderate: false).reverse
    else
      @images = Image.all.reverse_order.page params[:page]
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # GET /images/1
  # GET /images/1.json
  def moderate
    @image = Image.find(params["image_id"])
    @image.moderate = true
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_path(page: params["page"])}#, notice: 'Image was successfully moderated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def unmoderate
    @image = Image.find(params["image_id"])
    @image.moderate = false
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_path(page: params["page"])}#, notice: 'Image was successfully moderated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /images
  # POST /images.json
  def create

    # Save original image and image style transferred image if requested.

    if image_params["ios_data"]
      # Handle images from iOS
      # logger.info "Need to decode iOS image."
      tmp_params = {}

      tmp_params["data"] = parse_image_data(image_params["ios_data"])

      # If the user asks for style transfer, do it, else just save image.
      if image_params["style_transfer"] == "true"
        # Send base64 image data to have image transfer applied
        tmp_image_id_from_deep_dream = 1

        response_from_deep_dream = HTTParty.put(
          URI.parse(ENV["deep_dream_server"] + "/image" + tmp_image_id_from_deep_dream.to_s),
          body: image_params.to_json,
          headers: {
            'Content-Type' => 'application/json', 
            'Accept' => 'application/json'
          }
        )

        # If we get useful data back, save it.
        if response_from_deep_dream.code == 200
          tmp_params["style_data"] = parse_image_data(response_from_deep_dream["image" + tmp_image_id_from_deep_dream.to_s])
        end
      end

      # byebug
      @image = Image.new(tmp_params)

      # Moderate the image by default
      @image.moderate = true

      clean_tempfile
    else
      # Just create the image as usual
      @image = Image.new(image_params)
    end    

    respond_to do |format|
      if @image.save

        # Broadcast update
        params[:page] = "home"
        ImageChannel.broadcast_to(
          "image_#{params[:page]}",
          data_url: @image.data_url(:thumb_2x),
          data_id: @image.id,
          data_created_at: @image.created_at
        )

        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        logger.info @image.errors.full_messages
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def parse_image_data(base64_image)
      filename = "upload-image"
      in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]

      @tempfile = Tempfile.new(filename)
      @tempfile.binmode
      @tempfile.write Base64.decode64(base64_image)#.force_encoding("binary")
      @tempfile.rewind

      # for security we want the actual content type, not just what was passed in
      content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]

      # we will also add the extension ourselves based on the above
      # if it's not gif/jpeg/png, it will fail the validation in the upload model
      extension = content_type.match(/gif|jpeg|png/).to_s
      filename += ".#{extension}" if extension

      # byebug

      ActionDispatch::Http::UploadedFile.new({
        tempfile: @tempfile,
        content_type: content_type,
        filename: filename
      })
    end

    def clean_tempfile
      if @tempfile
        @tempfile.close
        @tempfile.unlink
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:data, :ios_data, :style_transfer, :style_data, :moderate)
    end
end
