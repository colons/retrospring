$(document).on "click", "button[name=qb-ask]", ->
  btn = $(this)
  btn.button "loading"
  promote = btn[0].dataset.promote == "true"
  $("textarea[name=qb-question]").attr "readonly", "readonly"
  anonymousQuestion = if $("input[name=qb-anonymous]")[0] != undefined
    $("input[name=qb-anonymous]")[0].checked
  else
    true
  $.ajax
    url: '/ajax/ask' # TODO: find a way to use rake routes instead of hardcoding them here
    type: 'POST'
    data:
      rcpt: $("input[name=qb-to]").val()
      question: $("textarea[name=qb-question]").val()
      anonymousQuestion: anonymousQuestion
    success: (data, status, jqxhr) ->
      if data.success
        $("textarea[name=qb-question]").val ''
        if promote
          $("div#question-box").hide()
          $("div#question-box-promote").show()
      showNotification data.message, data.success
    error: (jqxhr, status, error) ->
      console.log jqxhr, status, error
      showNotification "An error occurred, a developer should check the console for details", false
    complete: (jqxhr, status) ->
      btn.button "reset"
      $("textarea[name=qb-question]").removeAttr "readonly"