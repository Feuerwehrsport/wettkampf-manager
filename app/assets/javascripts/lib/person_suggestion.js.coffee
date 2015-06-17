class PersonSuggestion
  constructor: () ->
    @lastValue = ""

    $(document).on "keyup", '#person_suggestion', () =>
      newValue = $('#person_suggestion').val()
      if @lastValue isnt newValue
        @lastValue = newValue
        @updateSuggestions()

        for name, i in newValue.split(" ")
          if i is 0
            $('#person_first_name').val(name)
          else
            $('#person_last_name').val(name)
    $(document).on "change", '#person_first_name, #person_last_name', () ->
      $('#person_fire_sport_statistics_person_id').val("")

  updateSuggestions: () =>
    table = $('.suggestions-entries table')
    params =
      name: @lastValue
      gender: $('#person_gender').val()
      team_name: $('#person_suggestion').data('team-name')
    $.get "/fire_sport_statistics/suggestions/people", params, (entries) =>
      table.children().remove()
      for entry in entries
        table.append(@buildTr(entry))

  buildTr: (entry) ->
    $('<tr/>')
    .append($('<td/>').text(entry.first_name).addClass("first_name"))
    .append($('<td/>').text(entry.last_name).addClass("last_name"))
    .append($('<td/>').text(entry.teams.map( (t) -> t.short).join(", ")).addClass("team"))
    .click () ->
      $('#person_first_name').val(entry.first_name)
      $('#person_last_name').val(entry.last_name)
      $('#person_gender').val(entry.gender)
      $('#person_fire_sport_statistics_person_id').val(entry.id)

    

$ () ->
  new PersonSuggestion