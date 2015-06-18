#= require lib/person_suggestion
#= require lib/edit_assessment_requests

$ () ->
  $(document).on 'ajax:complete', '#without-statistics-id-index form', () ->
    setTimeout () ->
      $(document).refreshPartials()
    , 150
    true