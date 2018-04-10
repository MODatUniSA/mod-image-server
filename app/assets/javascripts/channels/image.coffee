App.image = App.cable.subscriptions.create { channel: "ImageChannel", page: "home" },
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("ImageChannel is connected.")

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log("ImageChannel is disconnected.")

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log("ImageChannel received: " + data)
    @prependTableData(data)

  prependTableData: (data) ->

    # Update home page slideshow javascript to show new image
    @updateSlideshowJavascript(data)

    # Update images index list
    html = @createImagesIndexHtml(data)
    $(".row").prepend(html)
 
  createSlideshowImageHtml: (data) ->
    """
    <img src="#{data.data_url}" class="slide" style="opacity: 1;">
    """

  createImagesIndexHtml: (data) ->
    """
    <div class="col-md-4">
      <div class="card mb-4 box-shadow">
        <a href="/images/#{data.data_id}"><img class="card-img-top" src="#{data.data_url}" alt="Thumb 2x upload image" /></a>
        <div class="card-body">
          <!-- <p class="card-text">Description text if needed</p> -->
          <div class="d-flex justify-content-between align-items-center">
            <div class="btn-group">
              <a class="btn btn-sm btn-outline-danger" href="/images/#{data.data_id}/moderate">Moderate</a>
              <a class="btn btn-sm btn-outline-secondary" href="/images/#{data.data_id}/edit">Edit</a>
            </div>
            <small class="text-muted">Just now!</small>
          </div>
        </div>
      </div>
    </div>
    """

  updateSlideshowJavascript: (data) ->
    # Mark all images opacity to 0 to make them invisible
    $.each $('.slide'), (index, value) ->
      value.style.opacity = 0
      return
    # Show new image
    html = @createSlideshowImageHtml(data)
    $(".slider-wrapper").append(html)
    # Clear the current slider and reset it to include the new image
    if typeof slider != 'undefined'
      slider.reset()