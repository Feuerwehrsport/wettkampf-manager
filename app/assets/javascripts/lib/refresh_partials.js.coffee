do ($ = jQuery, window, document) ->

  pluginName = 'refreshPartials'
  defaults = {
    partialSelector: '.refreshable'
    url: window.location.href
  }

  # The actual plugin constructor
  class Plugin
    constructor: (@element, options) ->
      @settings = $.extend({}, defaults, options)
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @partials = $(@settings.partialSelector, @element)
      if @partials.length > 0
        @highlightWaitingPartials()
        $.ajax(@settings.url, { cache: false, success: @refreshBySource })

    highlightWaitingPartials: ->
      @partials.each ->
        $(this).css({ opacity: '0.2', transition: 'opacity 300ms ease-out' })

    refreshBySource: (newSource) =>
      newHtml = $(newSource)
      @partials.each ->
        id = $(this).attr('id')
        replacement = newHtml.find('#' + id)
        if replacement.length is 1
          $(this).html(replacement.html())
          $(this).css({ opacity: '1.0' })
      $(@element).trigger('partials-refreshed')

  $.fn[pluginName] = (options) ->
    @each ->
      #unless $.data @, "plugin_#{pluginName}"
      $.data(this, "plugin_#{pluginName}", new Plugin(this, options))


  # DEBUG

  # $ ->
  #   $(document).refreshPartials()
  #   $(document).refreshPartials()
  # window.setInterval (-> $(document).refreshPartials()), 4000
