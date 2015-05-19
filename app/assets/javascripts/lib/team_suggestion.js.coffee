class TeamSuggestion
  constructor: () ->
    @lastValue = ""

    $(document).on "keyup", '#team_name', () =>
      newValue = $('#team_name').val()
      if @lastValue isnt newValue
        @lastValue = newValue
        @updateSuggestions()

  updateSuggestions: () =>
    table = $('.suggestions-entries').slideDown().find('table')
    params =
      name: @lastValue
    $.get "/fire_sport_statistics/suggestions/teams", params, (entries) =>
      console.log(entries)
      table.children().remove()
      for entry in entries
        table.append(@buildTr(entry))

  buildTr: (entry) ->
    $('<tr/>')
    .append($('<td/>').text(entry.name))
    .click () ->
      $('.suggestions-entries').slideUp()
      $('#team_name').val(entry.name)


$ () ->
  new TeamSuggestion