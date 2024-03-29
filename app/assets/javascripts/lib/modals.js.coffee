@Modals = {
  modals: []
  push: (content) ->
    modal = $(content).prependTo('body').modal()
    @modals.push(modal)
    $(document).trigger('modal.ready', [modal])
  pop: ->
    return if Modals.modals.length == 0
    modal = @modals.pop()
    modal.modal('hide')
    modal.on 'hidden.bs.modal', ->
      modal.remove()
      $(document).refreshPartials()
}

$(document).on 'submit', '.modal form', ->
  Modals.pop()
