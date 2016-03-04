$ () ->
  $('.edit-time').each () ->
    context = $(this)
    disableHandler = () ->
      if $(this).val() == "valid"
        context.find('.time-entries').removeClass('disabled').find('input:first').focus()
      else
        context.find('.time-entries').addClass('disabled')
    $('input:radio', context).on('change', disableHandler).trigger('change')

    
