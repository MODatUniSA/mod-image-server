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
    $(".images-index-table").append(html)
 
  createSlideshowImageHtml: (data) ->
    """
    <img src="#{data.data_url}" class="slide" style="opacity: 1;">
    """

  createImagesIndexHtml: (data) ->
    """
    <tr>
      <td><img src="#{data.data_url}" width="100" height="100"></td>
      <td>Whoa!</td>
      <td>Where did this come from?</td>
      <td>Nobody knows. (Simon knows)</td>
    </tr>
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
    slider.reset()