class TeamSuggestion
  constructor: () ->
    @lastValue = ""
    @shortcutChanged = false

    $(document).on "keyup", '#team_name', () =>
      newValue = $('#team_name').val()
      if @lastValue isnt newValue
        @lastValue = newValue
        @setShortcut(newValue) unless @shortcutChanged
        @updateSuggestions()

    $(document).on "keyup", '#team_shortcut', () =>
      @shortcutChanged = true

    $(document).on 'modal.ready', () =>
      @lastValue = ""
      $('#team_name').trigger('keyup')

  updateSuggestions: () =>
    table = $('.suggestions-entries').slideDown().find('table')
    params =
      name: @lastValue
    $.get "/fire_sport_statistics/suggestions/teams", params, (entries) =>
      table.children().remove()
      for entry in entries
        table.append(@buildTr(entry))

  buildTr: (entry) =>
    $('<tr/>')
    .append($('<td/>').text(entry.name))
    .click () =>
      $('.suggestions-entries').slideUp()
      $('#team_name').val(entry.name)
      console.log(entry)
      $('#team_fire_sport_statistics_team_id').val(entry.id)
      $('#team_federal_state_id').val(entry.federal_state_id)
      @setShortcut(entry.short)
      @shortcutChanged = false

  setShortcut: (shortcutValue) ->
    $('#team_shortcut').val(shortcutValue.substr(0, 12))



$ () ->
  new TeamSuggestion