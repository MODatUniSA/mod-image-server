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
    return
  return
