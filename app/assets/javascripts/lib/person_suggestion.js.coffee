class PersonSuggestion
  constructor: ->
    @lastValue = ''

    $(document).on 'keyup', '#person_suggestion', =>
      newValue = $('#person_suggestion').val()
      if @lastValue isnt newValue and newValue isnt ''
        @lastValue = newValue
        @updateSuggestions()

        for name, i in newValue.split(' ')
          if i is 0
            $('#person_first_name').val(name)
          else
            $('#person_last_name').val(name)
    $(document).on 'modal.ready', ->
      $('#person_suggestion').trigger('keyup')

    $(document).on 'change', '#person_first_name, #person_last_name', ->
      $('#person_fire_sport_statistics_person_id').val('')

  updateSuggestions: =>
    table = $('.suggestions-entries table')
    params = {
      name: @lastValue
      team_name: $('#person_suggestion').data('team-name')
    }

    suggestion_gender = $('#person_gender').val()
    params.gender = suggestion_gender if suggestion_gender

    real_gender = $('#person_suggestion').data('gender')
    params.real_gender = real_gender if real_gender

    $.get '/fire_sport_statistics/suggestions/people', params, (entries) =>
      table.children().remove()
      for entry in entries
        table.append(@buildTr(entry))

  buildTr: (entry) ->
    $('<tr/>')
    .append($('<td/>').text(entry.first_name).addClass('first_name'))
    .append($('<td/>').text(entry.last_name).addClass('last_name'))
    .append($('<td/>').text(entry.teams.map( (t) -> t.short).join(', ')).addClass('team'))
    .click ->
      $('#person_first_name').val(entry.first_name)
      $('.fire-sport-statistics-person .first-name').text(entry.first_name)
      $('#person_last_name').val(entry.last_name)
      $('.fire-sport-statistics-person .last-name').text(entry.last_name)
      $('.fire-sport-statistics-person .teams').text(entry.teams.map( (t) -> t.short).join(', '))
      $('#person_gender').val(entry.gender)
      $('#person_fire_sport_statistics_person_id').val(entry.id)

$ ->
  new PersonSuggestion
