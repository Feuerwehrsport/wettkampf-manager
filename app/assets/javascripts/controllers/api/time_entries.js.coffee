#= require lib/jquery.cookie
#= require lib/enter_times

$ ->
  $('#preselect-list input').change ->
    $.cookie('preselect-list', $(@).val())
  $("#preselect-list input[value=#{$.cookie('preselect-list')}]").click()

  $('#time-entries-refreshable').each ->
    refresh = () ->
      $(document).refreshPartials()
      setTimeout(refresh, 20000)
    setTimeout(refresh, 20000)
    
  $('.waiting-score-list-switch').click ->
    if $(@).hasClass('active')
      $(@).removeClass('active')
      $(@).parent().find('table').hide()
    else
      $(@).addClass('active')
      $(@).parent().find('table').show()
  
  if result = window.location.hash.match(/^#list-(\d+)$/)
    $(".waiting-score-list-switch.list-#{result[1]}").trigger('click')
  else if $(".waiting-score-list-switch.#{$.cookie('preselect-list')}").length > 0
    $(".waiting-score-list-switch.#{$.cookie('preselect-list')}").trigger('click')
  else
    $('.discipline-matches .waiting-score-list-switch').trigger('click')