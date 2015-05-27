handlers = []
resetHandler = () ->
  $('.assessment-request').each () ->
    context = $(this)
    checkbox = context.find("input[type=checkbox]")
    if $.inArray(checkbox[0], handlers) < 0
      checkbox.change(() ->
        opacity = if checkbox.is(':checked') then 1 else 0.3
        context.find('.edit-assesment-type').css(opacity: opacity)
      ).change()
      handlers.push(checkbox[0])
      context.find('select').change( () ->
        if $(this).val() is 'group_competitor'
          context.find('.group-competitor-order').show()
        else
          context.find('.group-competitor-order').hide()
      ).change()



$ () ->
  $(document).on 'modal.ready hidden.bs.modal', ->
    resetHandler()