#= require lib/person_suggestion
#= require lib/team_suggestion
#= require lib/edit_assessment_requests

updateOrder = () ->
  i = 0
  $('.registration-form').each () ->
    i++
    form = $(this)
    params =
      authenticity_token: form.find('input[name=authenticity_token]').val()
      _method: 'patch'
      person:
        registration_order: i
    $.post form.attr('action'), params

bindSortedTable = () ->
  $('.people-index-table tbody').sortable(
    forcePlaceholderSize: true
    items: 'tr'
    placeholder: $('.people-index-table tr.placeholder').remove().removeClass('hide')
  ).on 'sortupdate', updateOrder


$ () ->
  bindSortedTable()
  $(document).on('partials-refreshed', bindSortedTable)