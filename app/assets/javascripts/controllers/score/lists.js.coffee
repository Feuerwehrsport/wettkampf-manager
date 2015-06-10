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

  $('#score_list_generator').change(() ->
    type = $(@).val()
    $('.generator-config').each (i, elem) ->
      $elem = $(elem)
      if $.inArray(type, $elem.data('classes').split(" ")) < 0
        $elem.hide()
      else
        $elem.show()
  ).change()

  $('#score_list_assessment_id').change( () ->
    id = $(@).val()
    assessmentDependend = $('.assessment-dependend').css(opacity: 0.5)
    unless id.match(/^\d+$/)
      assessmentDependend.hide()
    else
      assessmentDependend.show()
      $('#score_list_result_ids').closest('.form-group').show()

      resultOptions = $('#score_list_result_ids option, #score_list_generator_attributes_result option').show()
      listOptions = $('#score_list_generator_attributes_before_list option').show()

      $.get "/assessments/#{id}/possible_associations.json", (data) ->
        resultOptions.each () ->
          option = $(@)
          if $.inArray(parseInt(option.val()), data.results) == -1
            option.hide()
            option.removeAttr('selected')
        listOptions.each () ->
          option = $(@)
          if $.inArray(parseInt(option.val()), data.lists) == -1
            option.hide()
            option.removeAttr('selected')

        # if only one result visible, we could select it and hide the select field
        if $('#score_list_result_ids option:not(:hidden)').length == 1
          $('#score_list_result_ids').closest('.form-group').hide().find('option:not(:hidden)').attr('selected', true)

        if $('#score_list_generator_attributes_before_list option:not(:hidden)').length == 1
          $('#score_list_generator_attributes_before_list option:not(:hidden)').attr('selected', true)
          
        if $('#score_list_generator_attributes_result option:not(:hidden)').length == 1
          $('#score_list_generator_attributes_result option:not(:hidden)').attr('selected', true)

        assessmentDependend.css(opacity: 1)
  ).change()