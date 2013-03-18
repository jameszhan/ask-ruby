window.Util = 
  alert : (msg, to) ->
    $(".alert").remove()
    $(to).before("<div class='alert'><a class='close' href='#' data-dismiss='alert'>x</a>#{msg}</div>")
    
  notice : (msg, to) ->
    $(".alert").remove()
    $(to).before("<div class='alert alert-success'><a class='close' data-dismiss='alert' href='#'>x</a>#{msg}</div>")
  

$(document).ready ->
  $(".main-question,.answer").delegate "form.vote_form", "ajax:before", (event) -> 
    $(this).find('button').attr("disabled", "disabled")
    return