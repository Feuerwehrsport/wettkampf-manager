$ () ->
  $('.edit-time').each () ->
    context = $(this)
    disableHandler = () ->
      if $(this).val() == "valid"
        context.find('.time-entries').removeClass('disabled')
      else
        context.find('.time-entries').addClass('disabled')
    $('input:radio', context).on 'ifChecked', disableHandler
    $('.iradio_minimal.checked input', context).each disableHandler

    
