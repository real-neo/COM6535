jQuery.ajaxSetup statusCode:
  401: ->
    alert "Please log in to continue."
  403: ->
    alert "Sorry, You are not authorised to access this page."
  423: ->
    alert "Sorry, Your account has been blocked!"