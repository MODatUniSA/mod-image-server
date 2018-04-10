# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# TODO: don't load this for every page.

# Simple slideshow
# https://codepen.io/gabrieleromanato/pen/dImly

pauseBetweenSlides = 5000

do ->

  window.Slideshow = (element) ->
    @el = document.querySelector(element)
    @init()
    return

  Slideshow.prototype =
    init: ->
      @wrapper = @el.querySelector('.slider-wrapper')
      @slides = @el.querySelectorAll('.slide')
      @previous = @el.querySelector('.slider-previous')
      @next = @el.querySelector('.slider-next')
      @index = 0
      @total = @slides.length
      @timer = null
      @action()
      @stopStart()
      return
    _slideTo: (slide) ->
      `var slide`
      currentSlide = @slides[slide]
      currentSlide.style.opacity = 1
      i = 0
      while i < @slides.length
        slide = @slides[i]
        if slide != currentSlide
          slide.style.opacity = 0
        i++
      return
    action: ->
      self = this
      self.timer = setInterval((->
        self.index++
        if self.index == self.slides.length
          self.index = 0
        self._slideTo self.index
        return
      ), pauseBetweenSlides)
      return
    stopStart: ->
      self = this
      self.el.addEventListener 'mouseover', (->
        clearInterval self.timer
        self.timer = null
        return
      ), false
      self.el.addEventListener 'mouseout', (->
        self.action()
        return
      ), false
      return
    reset: ->
      self = this
      clearInterval slider.timer
      self.timer = null
      self.slides = @el.querySelectorAll('.slide')
      self.action()
      return
  document.addEventListener 'DOMContentLoaded', ->
    window.slider = new Slideshow('#main-slider')

    # Set fullscreen toggle
    document.querySelector("#toggle_fullscreen").addEventListener 'click', ->
      console.log("Fullscreen clicked.")
      if document.fullscreenElement or document.webkitFullscreenElement or document.mozFullScreenElement or document.msFullscreenElement
        if document.exitFullscreen
          document.exitFullscreen()
        else if document.mozCancelFullScreen
          document.mozCancelFullScreen()
        else if document.webkitExitFullscreen
          document.webkitExitFullscreen()
        else if document.msExitFullscreen
          document.msExitFullscreen()
      else
        element = $('#main-slider').get(0)
        # TODO: work out a nice fullscreen ratio - and scale image to fit.
        # element.style.width = "100%"
        element.style.height = "100%"
        if element.requestFullscreen
          element.requestFullscreen()
        else if element.mozRequestFullScreen
          element.mozRequestFullScreen()
        else if element.webkitRequestFullscreen
          element.webkitRequestFullscreen Element.ALLOW_KEYBOARD_INPUT
        else if element.msRequestFullscreen
          element.msRequestFullscreen()
      return
    return

  return

