#= require jquery
#= require lib/refresh_partials
#= require lib/modals
#= require bootstrap-sprockets
#= require jquery_ujs
#= require lib/jquery.inputmask
#= require lib/jquery.inputmask.date.extensions
#= require lib/jquery.knob
#= require lib/jquery.sortable
#= require lib/jquery.balloon
#= require cocoon

$ ->
  shown = null
  $('.balloon').each ->
    element = $(this)
    element.click (event) ->
      unless shown?
        event.stopPropagation()
        options = {
          classname: 'balloon-tip'
          css: {
            border: 'solid 3px #5baec0'
            padding: '8px'
            fontSize: '13px'
            backgroundColor: '#fff'
            color: '#000'
            opacity: 1
          }
          tipSize: 12
          showDuration: 0
          hideDuration: 0
        }
        if element.data('balloon-content')?
          options.contents = element.data('balloon-content')
          options.html = true

        console.log options
        element.showBalloon(options)
        shown = element

  $('body').click (event) ->
    if shown? && $(event.target).parents('.balloon-tip').length == 0
      event.stopPropagation()
      shown.hideBalloon()
      shown = null
