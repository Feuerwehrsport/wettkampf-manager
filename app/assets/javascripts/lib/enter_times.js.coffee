$ () ->
  $('.edit-time').each () ->
    context = $(this)
    disableHandler = () ->
      if $('input[type=radio]:checked', context).val() is 'invalid'
        context.find('.time-entries').addClass('disabled')
      else
        context.find('.time-entries').removeClass('disabled')
    $('input:radio', context).on('change', disableHandler).trigger('change')

    selectRadioButton = ->
      if $(@).val() isnt ''
        $('input:radio[value=valid]', context).prop('checked', true)
        disableHandler()

    $('.time-entries input', context).on('change keydown paste', selectRadioButton)
    $($('.edit-time .time-entries input')[0]).focus()    
