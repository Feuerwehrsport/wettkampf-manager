#= require jquery-ui/draggable

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
      left: "#{x - 41}px"
      top: "#{y - 8}px"
  hide: =>
    @element.hide()
  show: =>
    @element.show()

class TextElement
  constructor: (@formElement) ->
    @formLeft = @formElement.find('.certificates_template_text_positions_left input')
    @formTop = @formElement.find('.certificates_template_text_positions_top input')
    @formSize = @formElement.find('.certificates_template_text_positions_size input')
    @formAlign = @formElement.find('.certificates_template_text_positions_align input')
    @formDestroy = @formElement.find('.certificates_template_text_positions__destroy input')
    description = @formElement.data('description')
    example = @formElement.data('example')


    @parent = $("#certificates-template-position")
    @arrow = new Arrow()
    @parentOffset = @parent.offset()
    @textAlign = 1
    @textAlign = textAligns.indexOf(@formAlign.val()) if @formAlign.val()
    @textSize = 4
    @textSize = textSizes.indexOf(parseInt(@formSize.val(), 10)) if @formSize.val()

    @element = $('<div/>').addClass('text-element')

    buttonLine = $('<div/>').appendTo(@element)
    @textAlignButton = $('<div/>').addClass("btn btn-default btn-xs glyphicon glyphicon-align-#{textAligns[@textAlign]}").appendTo(buttonLine)
    @textSizeButton = $('<div/>').addClass("btn btn-default btn-xs glyphicon glyphicon-chevron-up").appendTo(buttonLine)
    @removeButton = $('<div/>').addClass("btn btn-default btn-xs glyphicon glyphicon-remove").appendTo(buttonLine)
    @textLine = $('<div/>').addClass("text-line text-center").appendTo(@element).append(example)

    @addButton = $('<div/>').addClass('btn btn-default btn-xs btn-block').appendTo($('#position-buttons')).text(description).click(@show)
    
    if @formDestroy.val() is 'false'
      setTimeout( =>
        @show()
      , 10)


  show: =>
    console.log(@formLeft.val())
    @addButton.attr('disabled', true)
    @element.appendTo(@parent).draggable
      containment: "parent"
      drag: (event, ui) =>
        @movedTo(ui.offset.left, ui.offset.top)
    @textAlignButton.click(@nextAlign)
    @textSizeButton.click(@nextSize)
    @removeButton.click(@hide)
    @arrow.show()
    @formDestroy.val("false")
    @formAlign.val(textAligns[@textAlign])
    @formSize.val(textSizes[@textSize])
    @setPosition()
    @savePosition()

  hide: =>
    @addButton.removeAttr('disabled')
    @element.remove()
    @arrow.hide()
    @formDestroy.val("true")

  nextAlign: =>
    @textAlign = (@textAlign + 1) % textAligns.length
    @textAlignButton.removeClass('glyphicon-align-left glyphicon-align-center glyphicon-align-right')
    @textAlignButton.addClass("glyphicon-align-#{textAligns[@textAlign]}")
    @textLine.removeClass('text-center text-left text-right').addClass("text-#{textAligns[@textAlign]}")
    @formAlign.val(textAligns[@textAlign])
    @savePosition()

  nextSize: =>
    @textSize = (@textSize + 1) % textSizes.length
    @textSizeButton.removeClass('glyphicon-chevron-up glyphicon-chevron-down')
    @textLine.css(fontSize: "#{textSizes[@textSize]}px")
    if @textSize + 1 is textSizes.length
      @textSizeButton.addClass("glyphicon-chevron-down")
    else
      @textSizeButton.addClass("glyphicon-chevron-up")
    @formSize.val(textSizes[@textSize])
    @savePosition()

  movedTo: (left, top) =>
    @realLeft = left - @parentOffset.left
    @realTop = top - @parentOffset.top
    @savePosition()

  setPosition: =>
    width = parseInt(@element.css('width').replace(/px/, ''), 10)
    height = parseInt(@element.css('height').replace(/px/, ''), 10)

    if @formLeft.val() isnt ""
      left = parseInt(@formLeft.val(), 10)
    else
      left = parseInt(@parent.css('width').replace(/px/, '')/2, 10)

    if @formTop.val() isnt ""
      top = parseInt(@formTop.val(), 10)
    else
      top = parseInt(@parent.css('height').replace(/px/, '')/2, 10)


    switch textAligns[@textAlign]
      when 'center'
        left = left - width/2
      when 'right'
        left = left - width
    top = top - height

    @realTop = top
    @realLeft = left

    @element.css
      left: "#{left}px"
      top: "#{top}px"

  savePosition: =>
    @textLine.css(width: 'auto')
    @textLine.innerWidth(@textLine.innerWidth() + 100)
    width = parseInt(@element.css('width').replace(/px/, ''), 10)
    height = parseInt(@element.css('height').replace(/px/, ''), 10)
    switch textAligns[@textAlign]
      when 'left'
        @positionLeft = @realLeft
      when 'center'
        @positionLeft = @realLeft + width/2
      when 'right'
        @positionLeft = @realLeft + width
    @positionTop = @realTop + height
    @formLeft.val(@positionLeft)
    @formTop.val(@positionTop)

    @arrow.moveTo(@positionLeft, @positionTop)

$ ->
  new TemplateBackground()
  $('.text-position-form').each ->
    new TextElement($(@))

