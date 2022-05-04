#= require lib/jquery.ui.draggable
window.currentDraggableForPrintDocument = null
window.formElementTemplate = null
textAligns = ['left', 'center', 'right']
config = null

class TemplateBackground
  constructor: (element, src) ->
    if src
      element.addClass('form-print-document-template').css({
        backgroundImage: 'url(' + src + ')'
        backgroundSize: '100% 100%'
      })

class FormElement
  constructor: (@number, @element) ->
    @formInputs = {
      left: $("#certificates_template_text_fields_attributes_#{@number}_left")
      top: $("#certificates_template_text_fields_attributes_#{@number}_top")
      width: $("#certificates_template_text_fields_attributes_#{@number}_width")
      height: $("#certificates_template_text_fields_attributes_#{@number}_height")
      size: $("#certificates_template_text_fields_attributes_#{@number}_size")
      key: $("#certificates_template_text_fields_attributes_#{@number}_key")
      align: $("#certificates_template_text_fields_attributes_#{@number}_align")
      text: $("#certificates_template_text_fields_attributes_#{@number}_text")
      font: $("#certificates_template_text_fields_attributes_#{@number}_font")
      color: $("#certificates_template_text_fields_attributes_#{@number}_color")
      destroy: $("#certificates_template_text_fields_attributes_#{@number}__destroy")
    }
    if @get('key') isnt 'template'
      @textElement = new TextElement(this, @element)
    else
      @nextNumber = parseInt(@number, 10) + 1
      window.window.formElementTemplate = this

  set: (input, value) =>
    @formInputs[input].val(value)

  get: (input) =>
    @formInputs[input].val()

  newElement: (new_key, new_text) =>
    for key of @formInputs
      input = @formInputs[key].clone()
      input.attr('id', input.attr('id').replace(RegExp("_#{@number}_"), "_#{@nextNumber}_"))
      input.attr('name', input.attr('name').replace(RegExp("\\[#{@number}\\]"), "[#{@nextNumber}]"))
      input.insertAfter(@formInputs[key])
    $("#certificates_template_text_fields_attributes_#{@nextNumber}_key").val(new_key)
    $("#certificates_template_text_fields_attributes_#{@nextNumber}_text").val(new_text)
    $("#certificates_template_text_fields_attributes_#{@nextNumber}__destroy").val('false')
    (new FormElement(@nextNumber, @element)).focus()

    @nextNumber = @nextNumber + 1

  focus: =>
    @textElement.element.click()

class TextElement
  constructor: (@formElement, @parent) ->
    @description = config[@formElement.get('key')].description
    @example = config[@formElement.get('key')].example
    @example = @formElement.get('text') if @formElement.get('key') == 'text'
    @parentOffset = @parent.offset()
    buttonLine = $('<div/>').addClass('button-line')
    @textLine = $('<div/>').addClass('text-line')
    @element = $('<div/>').addClass('text-element').append(@textLine).append(buttonLine)
    @removeButton = $('<div/>').addClass('btn btn-info btn-xs glyphicon glyphicon-remove').appendTo(buttonLine)
    @moveButton = $('<div/>').addClass('btn btn-info btn-xs glyphicon glyphicon-move').appendTo(buttonLine)
    @show() if @formElement.get('destroy') is 'false'
    @element.click (e) =>
      window.currentDraggableForPrintDocument.blur() if window.currentDraggableForPrintDocument?
      window.currentDraggableForPrintDocument = this
      @.focus()
      e.stopPropagation()
      @registerBlur()
    @table = $('<table/>').addClass('information-table').appendTo('#field-tables')

  registerBlur: ->
      $(document).one 'click', (e) ->
        return unless window.currentDraggableForPrintDocument?
        if e.target.tagName is 'INPUT' && e.target.type is 'color'
          window.currentDraggableForPrintDocument.registerBlur()
        else
          window.currentDraggableForPrintDocument.blur()
          window.currentDraggableForPrintDocument = null

  setFontSize: =>
    textSize = 16
    textSize = parseInt(@formElement.get('size'), 10) if @formElement.get('size') isnt ''
    @textLine.css({ fontSize: "#{textSize}px", lineHeight: "#{textSize}px" })
    @formElement.set('size', textSize)


  show: =>
    @removeButton.click(@hide)
    @formElement.set('destroy', 'false')
    @setFontSize()
    @setSize()
    @setPosition()
    @setAlign()
    @setFont()
    @textLine.text(@example).attr('title', @description)
    @element.appendTo(@parent).draggable {
      containment: 'parent'
      handle: @moveButton
      drag: (event, ui) =>
        @movedTo(ui.offset.left, ui.offset.top)
    }
    @savePosition()

  focus: =>
    @element.addClass('is-focused')
    @regenerateTable()
    @table.show()
    document.title = @formElement.get('key')

  changeValue: (elem, distance) =>
    if elem is 'width' or elem is 'height'
      width = @formElement.get('width')
      height = @formElement.get('height')

      width = parseInt(width, 10) + distance if elem is 'width'
      height = parseInt(height, 10) + distance if elem is 'height'

      @resizeTo(width, height)
      @setSize()

    if elem is 'left' or elem is 'top'
      position = @element.position()
      position.left = position.left + distance if elem is 'left'
      position.top = position.top + distance if elem is 'top'
      @element.css(position)
      @movedTo(@element.offset().left, @element.offset().top)

    if elem is 'size'
      @formElement.set('size', parseInt(@formElement.get('size'), 10) + distance)
      @setFontSize()
      @regenerateTable()
    @formElement

  regenerateTable: =>
    elements = { size: 'Schrift', left: 'Links', top: 'Oben', width: 'Weite', height: 'Höhe' }
    @table.children().remove()
    $("<tr><th class='text-center' colspan=4>#{config[@formElement.get('key')].description}</th></tr>").appendTo(@table)
    $.each Object.keys(elements), (i, elem) =>
      val = @formElement.get(elem)
      tr = $('<tr/>').appendTo(@table)
      $('<td class="text-center"/>').appendTo(tr).append($('<div class="btn btn-xs btn-default">--</div>').click (e) =>
        e.stopPropagation()
        @changeValue(elem, -10)
      ).append($('<div class="btn btn-xs btn-default">-</div>').click (e) =>
        e.stopPropagation()
        @changeValue(elem, -1)
      )
      $("<th>#{elements[elem]}</th>").appendTo(tr)
      $("<td>#{val}</td>").appendTo(tr)
      $('<td class="text-center"/>').appendTo(tr).append($('<div class="btn btn-xs btn-default">+</div>').click (e) =>
        e.stopPropagation()
        @changeValue(elem, 1)
      ).append($('<div class="btn btn-xs btn-default">++</div>').click (e) =>
        e.stopPropagation()
        @changeValue(elem, 10)
      )

    alignLine = $('<td colspan=2 class="text-center"/>')
    $.each ['left', 'center', 'right'], (i, elem) =>
      btn = $("<div class=\"btn btn-xs btn-default\"><span class=\"glyphicon glyphicon-align-#{elem}\"/></div>").
      click( (e) =>
        e.stopPropagation()
        @formElement.set('align', elem)
        @setAlign()
        @regenerateTable()
      ).appendTo(alignLine)
      btn.addClass('btn-primary') if @formElement.get('align') is elem

    $('<tr/>').appendTo(@table).append('<td/>').append('<th>Text</th>').append(alignLine)

    fontLine = $('<td colspan=2 class="text-center"/>')
    $.each ['regular', 'bold'], (i, elem) =>
      btn = $("<div class=\"btn btn-xs btn-default\"><span class=\"glyphicon glyphicon-font\"/></div>").
      click( (e) =>
        e.stopPropagation()
        @formElement.set('font', elem)
        @setFont()
        @regenerateTable()
      ).appendTo(fontLine)
      btn.addClass('btn-primary') if @formElement.get('font') is elem

    $('<tr/>').appendTo(@table).append('<td/>').append('<th>Schrift</th>').append(fontLine)

    colorLine = $('<td colspan=2 class="text-center"/>')
    colorInput = $('<input type="color" value="#' + @formElement.get('color') + '"/>').appendTo(colorLine).change(=>
      color = colorInput.val().replace(/[^0-9A-F]/, '')
      @formElement.set('color', color.toUpperCase())
      @formElement.focus()
    )
    $('<tr/>').appendTo(@table).append('<td/>').append('<th>Farbe</th>').append(colorLine)
    btn = $('<div><span class="glyphicon glyphicon-resize-horizontal"/> Element zentrieren</div>').
    addClass('btn btn-xs btn-default').click( (e) =>
      e.stopPropagation()
      @adjustCenter()
    )
    $('<tr/>').appendTo(@table).append($('<td colspan="4" class="text-center"/>').append(btn))

  blur: =>
    @element.removeClass('is-focused')
    @table.hide()

  hide: =>
    @element.remove()
    @formElement.set('destroy', 'true')

  movedTo: (left, top) =>
    @realLeft = Math.round((left - @parentOffset.left) * 2)/2
    @realTop = Math.round((top - @parentOffset.top) * 2)/2
    @savePosition()
    @regenerateTable()

  adjustCenter: =>
    position = @element.position()
    position.left = 595 / 2 - parseInt(@formElement.get('width'), 10) / 2
    @element.css(position)
    @movedTo(@element.offset().left, @element.offset().top)

  resizeTo: (@width, @height) =>
    @width = Math.round(@width * 2) / 2
    @height = Math.round(@height * 2) / 2
    @formElement.set('width', @width)
    @formElement.set('height', @height)
    @regenerateTable()

  setFont: =>
    if @formElement.get('font') is 'regular'
      if @formElement.element.data('font-family-regular') isnt ''
        @textLine.css({ fontFamily: @formElement.element.data('font-family-regular'), fontWeight: 'normal' })
      else
        @textLine.css({ fontFamily: @formElement.element.data('initial'), fontWeight: 'normal' })
    else
      if @formElement.element.data('font-family-bold') isnt ''
        @textLine.css({ fontFamily: @formElement.element.data('font-family-bold'), fontWeight: 'normal' })
      else
        @textLine.css({ fontFamily: @formElement.element.data('initial'), fontWeight: 'bold' })

  setSize: =>
    if @formElement.get('width') isnt ''
      @width = parseInt(@formElement.get('width'), 10)
    else
      @width = 100

    if @formElement.get('height') isnt ''
      @height = parseInt(@formElement.get('height'), 10)
    else
      @height = 100
    @formElement.set('width', @width)
    @formElement.set('height', @height)
    @textLine.css {
      width: @width
      height: @height
    }

  setAlign: =>
    @textLine.css('textAlign', @formElement.get('align'))

  setPosition: =>
    if @formElement.get('left') isnt ''
      left = parseInt(@formElement.get('left'), 10)
    else
      left = parseInt(@parent.css('width').replace(/px/, ''), 10) / 2

    if @formElement.get('top') isnt ''
      top = (parseInt(@formElement.get('top'), 10) - 842) * -1
    else
      top = parseInt(@parent.css('height').replace(/px/, ''), 10) / 2


    @realTop = top
    @realLeft = left

    @element.offset {
      left: left
      top: top
    }

  savePosition: =>
    @positionLeft = @realLeft
    @positionTop = @realTop
    @formElement.set('left', @positionLeft)
    @formElement.set('top', (842) - @positionTop)


$ ->
  if $('#certificates-template-position').length > 0
    setTimeout(->
      element = $('#certificates-template-position')
      config = element.data('config')
      new TemplateBackground(element, element.data('background'))

      $('.certificates_template_text_fields_key').each ->
        number = $(this).find('input').attr('id').
        replace(/^certificates_template_text_fields_attributes_(\d+)_key/, '$1')
        new FormElement(number, element)

      newFieldHtml = $('.new-position-form').html()
      $('.new-position-form').remove()

      $('#add-new-field').click ->
        window.Modals.push(newFieldHtml)
        $('#certificates_text_field_key').change(->
          $('.form-group.certificates_text_field_text').toggle($(this).val() is 'text')
        ).change()
        $('.modal .btn.btn-primary').click (e) ->
          key = $('#certificates_text_field_key').val()
          return false if key is ''
          text = $('#certificates_text_field_text').val()
          Modals.pop()
          window.formElementTemplate.newElement(key, text)
          e.stopPropagation()
    , 300)
