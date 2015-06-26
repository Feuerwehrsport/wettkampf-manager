#= require lib/enter_times

listEntries = null

buildForm = () ->
  form = $('.score_list_form').hide().removeClass('hide').slideDown().submit () ->
    params =
      authenticity_token: form.find('input[name=authenticity_token]').val()
      _method: 'patch'
      score_list:
        entries_attributes: listEntries

    $.post form.attr('action'), params, () ->
      $(document).refreshPartials()
      listEntries = null
    false
    


recalculateRuns = () ->
  buildForm() if listEntries is null
  listEntries = []

  table = $('.sorted_table')
  trackCount = table.data('track-count')
  
  table.animate opacity: 0, () ->

    track = 0
    run = 1
    table.find('tbody tr').each () ->
      tr = $(this)
      tr.removeClass("next-run")
      tr.addClass("next-run") if track is trackCount - 1
      if track is 0
        tr.find('.run').text(run)
      else
        tr.find('.run').text("")

      track++
      tr.find('.track').text(track)
      
      id = tr.data('id')
      if id
        listEntries.push
          id: id
          run: run
          track: track

      if track is trackCount
        track = 0
        run++

    table.animate opacity: 1, () ->

bindSortedTable = () ->
  $('.sorted_table tbody').sortable(
    forcePlaceholderSize: true
    items: 'tr'
    placeholder: $('.sorted_table tr.placeholder').remove().removeClass('hide')
  ).on 'sortupdate', recalculateRuns

$ () ->
  bindSortedTable()
  $(document).on('partials-refreshed', bindSortedTable)

  $('select.select-list-generator').change(() ->
    type = $(@).val()
    $(@).closest('form').find('.generator-config').each (i, elem) ->
      $elem = $(elem)
      if $.inArray(type, $elem.data('classes').split(" ")) < 0
        $elem.hide()
      else
        $elem.show()
  ).change()

  $('select.select-assessments').change( () ->
    ids = $(@).val()
    context = $(@).closest('form')
    
    nameInput = $('.input-name', context)
    options = $(@).find('option:selected')
    if options.length is 1
      nameInput.val(options.text())
    else if options.length is 0
      nameInput.val(nameInput.data('name'))
    else
      nameInput.val("#{nameInput.data('name')} - gemischt")


    assessmentDependend = $('.assessment-dependend', context).css(opacity: 0.5)
    if !ids || ids.length is 0
      assessmentDependend.hide()
    else
      assessmentDependend.show()

      resultOptions = $('.select-result option, .select-results option', context).hide().removeAttr('selected')
      listOptions = $('.select-before-list option', context).hide().removeAttr('selected')

      handleResult = () ->
        for selector in ['.select-results option:not(:hidden)', '.select-result option:not(:hidden)', '.select-before-list option:not(:hidden)']
          $(selector, context).attr('selected', true) if $(selector, context).length == 1
        assessmentDependend.css(opacity: 1)


      callbackCount = 0
      $.each ids, (i, id) ->
        $.get "/assessments/#{id}/possible_associations.json", (data) ->
          resultOptions.each () ->
            option = $(@)
            if $.inArray(parseInt(option.val()), data.results) isnt -1
              option.show()
          listOptions.each () ->
            option = $(@)
            if $.inArray(parseInt(option.val()), data.lists) isnt -1
              option.show()
          callbackCount++
          handleResult() if callbackCount == ids.length
  ).change()