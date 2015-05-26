handlers = []
resetHandler = () ->
  $('.assessment-request').each () ->
    context = $(this)
    checkbox = context.find("input[type=checkbox]")
    if $.inArray(checkbox[0], handlers) < 0
      checkbox.change(() ->
        opacity = if checkbox.is(':checked') then 1 else 0.3
        context.find('.team_requests_assessment_type').css(opacity: opacity)
        context.find('.person_requests_assessment_type').css(opacity: opacity)
      ).change()
      handlers.push(checkbox[0])

$ () ->
  $(document).on 'modal.ready hidden.bs.modal', ->
    resetHandler()