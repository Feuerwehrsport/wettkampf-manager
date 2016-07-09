#= require lib/jquery.ui.draggable

textAligns = ['left', 'center', 'right']
textSizes = [8, 10, 12, 14, 16, 18, 20, 22, 25, 28, 31, 35, 39]

class TemplateBackground
  constructor: ->
    @src = $('#template-background').attr('src')
    $('#template-background').remove()
    $("#certificates-template-position").css
      backgroundImage: 'url(' + @src + ')'
      backgroundSize: '100% 100%'

class Arrow
  constructor: ->
    @element = $('#template-arrow').clone().appendTo($("#certificates-template-position")).hide()
  moveTo: (x, y) =>
    @element.css
      left: "#{x - 38}px"
      top: "#{y - 20}px"
  hide: =>
    @element.hide()
  show: =>
    @element.show()

class FormElement
  constructor: (@formElement) ->
    @formInputs = 
      left: @formElement.find('.certificates_template_text_positions_left input')
      top: @formElement.find('.certificates_template_text_positions_top input')
      size: @formElement.find('.certificates_template_text_positions_size input')
      align: @formElement.find('.certificates_template_text_positions_align input')
      destroy: @formElement.find('.certificates_template_text_positions__destroy input')
    new TextElement(@)

  set: (input, value) =>
    @formInputs[input].val(value)

  get: (input) =>
    @formInputs[input].val()

  description: =>
    @formElement.data('description')

  example: =>
    @formElement.data('example')

class TextElement
  constructor: (@formElement) ->
    @parent = $("#certificates-template-position")
    @arrow = new Arrow()
    @parentOffset = @parent.offset()


    buttonLine = $('<div/>')
    @setAlign(buttonLine)
    @textLine = $('<div/>').addClass("text-line text-#{@currentAlign()}").append(@formElement.example())
    @setSize(buttonLine)
    @element = $('<div/>').addClass('text-element').append(@textLine).append(buttonLine)
    @removeButton = $('<div/>').addClass("btn btn-default btn-xs glyphicon glyphicon-remove").appendTo(buttonLine)
    @addButton = $('<div/>').addClass('btn btn-default btn-xs btn-block').appendTo($('#position-buttons')).text(@formElement.description()).click(@show)
    @show() if @formElement.get('destroy') is 'false'
    @setFont() 

  setFont: () =>
    font = @parent.data('font-family')
    @textLine.css(fontFamily: font) if font?

  setAlign: (buttonLine) =>
    @textAlign = 1
    @textAlign = textAligns.indexOf(@formElement.get('align')) if @formElement.get('align')
    @textAlignButton = $('<div/>').addClass("btn btn-default btn-xs glyphicon glyphicon-align-#{@currentAlign()}").appendTo(buttonLine)

  setSize: (buttonLine) =>
    @textSize = 4
    @textSize = textSizes.indexOf(parseInt(@formElement.get('size'), 10)) if @formElement.get('size')
    @textSizeButton = $('<div/>').addClass("btn btn-default btn-xs glyphicon glyphicon-chevron-up").appendTo(buttonLine)
    @textLine.css(fontSize: "#{textSizes[@textSize]}px", lineHeight: "#{textSizes[@textSize]}px")


  show: =>
    @addButton.attr('disabled', true)
    @element.appendTo(@parent).draggable
      containment: "parent"
      drag: (event, ui) =>
        @movedTo(ui.offset.left, ui.offset.top)
    @textAlignButton.click(@nextAlign)
    @textSizeButton.click(@nextSize)
    @removeButton.click(@hide)
    @arrow.show()
    @formElement.set('destroy', 'false')
    @formElement.set('align', textAligns[@textAlign])
    @formElement.set('size', textSizes[@textSize])
    @setPosition()
    @savePosition()

  hide: =>
    @addButton.removeAttr('disabled')
    @element.remove()
    @arrow.hide()
    @formElement.set('destroy', 'true')

  nextAlign: =>
    @textAlign = (@textAlign + 1) % textAligns.length
    @textAlignButton.removeClass('glyphicon-align-left glyphicon-align-center glyphicon-align-right')
    @textAlignButton.addClass("glyphicon-align-#{@currentAlign()}")
    @textLine.removeClass('text-center text-left text-right').addClass("text-#{@currentAlign()}")
    @formElement.set('align', textAligns[@textAlign])
    @savePosition()

  currentAlign: =>
    textAligns[@textAlign]

  nextSize: =>
    @textSize = (@textSize + 1) % textSizes.length
    @textSizeButton.removeClass('glyphicon-chevron-up glyphicon-chevron-down')
    @textLine.css(fontSize: "#{textSizes[@textSize]}px", lineHeight: "#{textSizes[@textSize]}px")
    if @textSize + 1 is textSizes.length
      @textSizeButton.addClass("glyphicon-chevron-down")
    else
      @textSizeButton.addClass("glyphicon-chevron-up")
    @formElement.set('size', textSizes[@textSize])
    @savePosition()

  movedTo: (left, top) =>
    @realLeft = left - @parentOffset.left
    @realTop = top - @parentOffset.top
    @savePosition()

  setPosition: =>
    width = parseInt(@element.css('width').replace(/px/, ''), 10)

    if @formElement.get('left') isnt ""
      left = parseInt(@formElement.get('left'), 10)
    else
      left = parseInt(@parent.css('width').replace(/px/, '')/2, 10)

    if @formElement.get('top') isnt ""
      top = parseInt(@formElement.get('top'), 10)
    else
      top = parseInt(@parent.css('height').replace(/px/, '')/2, 10)


    switch textAligns[@textAlign]
      when 'center'
        left = left - width/2
      when 'right'
        left = left - width

    @realTop = top
    @realLeft = left

    @element.offset
      left: left + @parentOffset.left
      top: top + @parentOffset.top

  savePosition: =>
    width = parseInt(@element.css('width').replace(/px/, ''), 10)
    switch textAligns[@textAlign]
      when 'left'
        @positionLeft = @realLeft
      when 'center'
        @positionLeft = @realLeft + width/2
      when 'right'
        @positionLeft = @realLeft + width
    @positionTop = @realTop
    @formElement.set('left', @positionLeft)
    @formElement.set('top', @positionTop)

    @arrow.moveTo(@positionLeft, @positionTop)

$ ->
  new TemplateBackground()
  $('.text-position-form').each ->
    new FormElement($(@))

