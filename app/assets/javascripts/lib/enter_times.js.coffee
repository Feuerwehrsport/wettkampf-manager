$ ->
  $('.edit-time').each ->
    context = $(this)
    disableHandler = ->
      if $('input[type=radio]:checked', context).val() is 'invalid'
        context.find('.time-entries').addClass('disabled')
      else
        context.find('.time-entries').removeClass('disabled')
    $('input:radio', context).on('change', disableHandler).trigger('change')

    selectRadioButton = ->
      if $(this).val() isnt ''
        $('input:radio[value=valid]', context).prop('checked', true)
        disableHandler()

    $('.time-entries input', context).on('change keydown paste', selectRadioButton)
    $($('.edit-time .time-entries input')[0]).focus()

  $('input.numeric.second_time').each ->
    input = $(this)
    group = input.parent()
    tr = group.closest('tr')
    label = group.find('label')
    text = label.text()
    input.on('change keyup paste', ->
      value = input.val()
      badInput = (not input[0].validity? or not input[0].validity.badInput)
      badValue = (value.match(/^\d+([.,]\d{1,2})?$/) or value.match(/^\s*$/))
      if badInput and badValue
        label.text(text)
        tr.removeClass('danger')
        $('button[type=submit]').prop('disabled', false)
      else
        label.text('Format: SS,MM')
        tr.addClass('danger')
        $('button[type=submit]').prop('disabled', true)
    )
