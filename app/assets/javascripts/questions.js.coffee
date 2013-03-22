# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Questions =
  preview: (body, preview_box) ->
    preview_box.text "Loading..."

    $.post "/questions/preview",
      "body": body,
      (data) ->
        preview_box.html data.body
      "json"
      
  hookPreview: (switcher, textarea, context_selector) ->
    ctx = $(context_selector)
    preview_box = $(document.createElement("div")).addClass "preview_box"
    $(textarea, ctx).after preview_box
    
    $(".edit a").click ->
      form = $(this).closest("form")
      $(".preview", form.find(switcher)).removeClass("active")
      $(this).parent().addClass("active")
      $(".preview_box", form).hide()
      $(textarea, form).show()
      false
    $(".preview a").click ->
      form = $(this).closest("form")
      $(".edit", form.find(switcher)).removeClass("active")
      $(this).parent().addClass("active")
      preview_box = $(".preview_box", form)
      preview_box.show()
      $(textarea, form).hide()
      Questions.preview($(textarea, form).val(), preview_box)
      false

  answerCallback: (success, msg) ->
    if success
      Util.notice(msg, '#new_answer')
    else
      Util.alert(msg, '#new_answer')
      
  hookQuestionsCallback: (context) ->
    parent = $(context)
    $('.follow-question', parent).on "click", () -> 
      $.post $(this).data('url')
      if $(this).data('status')        
        $(this).text('Follow')
        $(this).data("status", false)
      else
        $(this).text('Unfollow')
        $(this).data("status", true)      
        
  hookAnswersCallback: (context) -> 
    parent = $(context)
    $(".answer-actions > a.btn-danger", parent).on "ajax:complete", (e, xhr, status) ->
      if status == 'nocontent'
        $(this).closest('.answer').remove()
    $(".edit-answer-button", parent).on "click", () ->
      $('#edit_answer_form_modal').find(".modal-body").html($(this).next("div.edit-answer-form").html())
      Questions.hookPreview(".editor_toolbar", ".answers_editor", "#edit_answer_form_modal")
  
  hookCommentsCallback: (context) ->
    parent = $(context)
    $('a.delete-comment', parent).on "ajax:complete", (e, xhr, status) ->
      if status == "nocontent"
        $(this).closest('.comment-content').remove()
    $(".comment label", parent).on "click", () ->
      $(this).hide().next(".comment-form").show()
    $(".comment-form a", parent).on "click", () ->
      $(this).closest(".comment-form").hide().closest(".comment").find("label").show()
        
        

$(document).ready ->
  $("#question_add_image").on "click", () ->
    $("#question_upload_images").click()
    return false
    
  Questions.hookQuestionsCallback('body')  
  Questions.hookAnswersCallback('body') 
  Questions.hookCommentsCallback('body')  
  Questions.hookPreview(".editor_toolbar", ".questions_editor", 'body')
  Questions.hookPreview(".editor_toolbar", ".answers_editor", '#new_answer')
  return
