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
    # Update table
    html = @createImage(data)
    $(".slider-wrapper").append(html)
    # TODO: Update slideshow javascript to show new image
 
  createImage: (data) ->
    """
    <p>TODO: Update javascript for #{data.data_url}</p>
    <img src="#{data.data_url}" class="slide">
    """