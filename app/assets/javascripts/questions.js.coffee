# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Questions =
  preview: (body, preview_box) ->
    preview_box.text "Loading..."

    $.post "/markdown/preview",
      "body": body,
      (data) ->
        preview_box.html data.body
      "json"
      
  hookPreview: (switcher, textarea, context_selector) ->
    ctx = $(context_selector)
    preview_box = $(document.createElement("div")).addClass "preview_box"
    $(textarea, ctx).after preview_box
    
    ctx.on "click", ".edit > a", ->
      form = $(this).closest("form")
      $(".preview", form.find(switcher)).removeClass("active")
      $(this).parent().addClass("active")
      $(".preview_box", form).hide()
      $(textarea, form).show()
      false
    ctx.on "click", ".preview > a", ->
      form = $(this).closest("form")
      $(".edit", form.find(switcher)).removeClass("active")
      $(this).parent().addClass("active")
      preview_box = $(".preview_box", form)
      preview_box.show()
      $(textarea, form).hide()
      markdown_content = $(textarea, form).val()
      console.log(markdown_content)
      Questions.preview(markdown_content, preview_box)
      false

  answerCallback: (success, msg) ->
    if success
      Util.notice(msg, '#new_answer')
    else
      Util.alert(msg, '#new_answer')
      
  hookQuestionsCallback: (context) ->
    $(context).on "click", ".follow-question", (e)->
      $.post $(this).data('url')
      if $(this).data('status')        
        $(this).text('Follow')
        $(this).data("status", false)
      else
        $(this).text('Unfollow')
        $(this).data("status", true)      
        
  hookAnswersCallback: (context) -> 
    parent = $(context)
    parent.on "confirm:complete", ".answer-actions > a.btn-danger", (e, accept) ->
      $(this).closest('.answer').remove() if accept
      return
    parent.on "click", ".edit-answer-button", (e) ->
      $('#edit_answer_form_modal').find(".modal-body").html($(this).next("div.edit-answer-form").html())
      Questions.hookPreview(".editor_toolbar", ".answers_editor", "#edit_answer_form_modal")
      return
  
  hookCommentsCallback: (context) ->
    parent = $(context)
    parent.on "confirm:complete", "a.delete-comment", (e, accept) ->      
      $(this).closest('.comment-content').remove() if accept
      return
    parent.on "click", ".comment label", () ->
      $(this).hide().next(".comment-form").show()
      return
    parent.on "click", ".comment-form a", () ->
      $(this).closest(".comment-form").hide().closest(".comment").find("label").show()
      return
        
        

$(document).ready ->
  # enable chosen js
  $('.chzn-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
  
  $("#question_add_image").on "click", () ->
    $("#question_upload_images").click()
    return false
    
  Questions.hookQuestionsCallback('body')  
  Questions.hookAnswersCallback('body') 
  Questions.hookCommentsCallback('body')  
  Questions.hookPreview(".editor_toolbar", ".questions_editor", 'body')
  Questions.hookPreview(".editor_toolbar", ".answers_editor", '#new_answer')
  return
