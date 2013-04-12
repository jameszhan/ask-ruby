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
      
  appendImagesToEditor: (srcs, editor)->
    caret_pos = editor.caret()
    src_merged = ""
    for src in srcs
      src_merged = "![](#{src})\n"
    source = editor.val()
    before_text = source.slice(0, caret_pos)
    editor.val(before_text + src_merged + source.slice(caret_pos + 1, source.count))
    editor.caret(caret_pos + src_merged.length)
    editor.focus()
  
  initUploader: (context)->
    parent = $(context)
    parent.on "click", "a.add-photo-image[rel=new_photo]", (e)->
      $(this).closest(".question-form-box, .answer-form-box").find(".upload-photo-images").click()
      return false
      
    parent.find("form.upload-photo-form").fileupload
      dataType: "json"
      add: (e, data) ->
        types = /(\.|\/)(gif|jpe?g|png)$/i
        file = data.files[0]       
        if types.test(file.type) || types.test(file.name)
          upload_button = $(this).closest(".question-form-box, .answer-form-box").find("a.add-photo-image[rel=new_photo]")
          upload_button.hide().before("<span class='loading'>上传中...</span>")
          data.submit()
        else
          alert("#{file.name} is not a gif, jpeg, or png image file")
        return
        
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
        return

      done: (e, data) ->
        editor = $(this).closest(".question-form-box, .answer-form-box").find("textarea.questions_editor, textarea.answers_editor")
        Questions.appendImagesToEditor([data.result.image.url], editor)
        upload_button = $(this).closest(".question-form-box, .answer-form-box").find("a.add-photo-image[rel=new_photo]")
        upload_button.parent().find("span").remove()
        upload_button.show()
        return

      fail: (e, data) ->
        upload_button = $(this).closest(".question-form-box, .answer-form-box").find("a.add-photo-image[rel=new_photo]")
        upload_button.parent().find("span").remove()
        upload_button.show()
        alert("#{data.files[0].name} failed to upload.")
        return
    return
          
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
      Questions.initUploader('#edit_answer_form_modal')
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
    no_results_text: 'No Search Results...'
  $(".questions  > .question:even").css("background-color", "#fcfcfc")
  Questions.initUploader('body')
  Questions.hookQuestionsCallback('body')  
  Questions.hookAnswersCallback('body') 
  Questions.hookCommentsCallback('body')  
  Questions.hookPreview(".editor_toolbar", ".questions_editor", 'body')
  Questions.hookPreview(".editor_toolbar", ".answers_editor", '#new_answer')
  return
