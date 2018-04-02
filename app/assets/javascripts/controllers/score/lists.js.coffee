#= require lib/enter_times

listEntries = null

buildForm = ->
  $(window).bind 'beforeunload', ->
    'Wollen Sie die veränderte Reihenfolge verwerfen?'

  form = $('.score_list_form').hide().removeClass('hide').slideDown().submit ->
    params = {
      authenticity_token: form.find('input[name=authenticity_token]').val()
      _method: 'patch'
      score_list: { entries_attributes: listEntries }
    }

    $.post form.attr('action'), params, ->
      $(document).refreshPartials()
      listEntries = null
    false

recalculateRuns = ->
  buildForm() if listEntries is null
  listEntries = []

  table = $('.sorted_table')
  trackCount = table.data('track-count')
  
  table.animate { opacity: 0 }, ->

    track = 0
    run = 1
    table.find('tbody tr').each ->
      tr = $(this)
      tr.removeClass('next-run')
      tr.addClass('next-run') if track is trackCount - 1
      if track is 0
        tr.find('.run').text(run)
      else
        tr.find('.run').text('')

      track++
      tr.find('.track').text(track)
      
      id = tr.data('id')
      if id
        listEntries.push({
          id: id
          run: run
          track: track
        })

      if track is trackCount
        track = 0
        run++

    table.animate { opacity: 1 }, ->
      undefined

bindSortedTable = ->
  $(window).unbind('beforeunload')

  $('.sorted_table tbody').sortable({
    forcePlaceholderSize: true
    items: 'tr'
    placeholder: $('.sorted_table tr.placeholder').remove().removeClass('hide')
  }).on('sortupdate', recalculateRuns)

  $('.sorted_table tbody tr').each ->
    tr = $(this)
    down = $('<div class="btn btn-default btn-xs" title="Ganz nach unten">↡</div>').click ->
      last = tr.parent().find('tr:last')
      unless last.is(tr)
        tr.insertAfter(last)
        recalculateRuns()
    up = $('<div class="btn btn-default btn-xs" title="Ganz nach oben">↟</div>').click ->
      first = tr.parent().find('tr:first')
      unless first.is(tr)
        tr.insertBefore(first)
        recalculateRuns()
    $('<td/>').append(down).append(up).appendTo(tr)


$ ->
  bindSortedTable()
  $(document).on('partials-refreshed', bindSortedTable)
