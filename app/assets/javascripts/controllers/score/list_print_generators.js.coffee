generatePrintList = ->
  printList = []
  $('#sortable-list-elements').find('li').each (i, elem) ->
    printId = $(elem).data('print-id')
    if printId is 'finish'
      $('#score_list_print_generator_print_list').val(printList.join(','))
      return

    printList.push(printId)

$ ->
  $('#sortable-list-elements').sortable().on('sortupdate', generatePrintList)
  generatePrintList()