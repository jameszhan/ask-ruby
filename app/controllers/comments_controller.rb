class CommentsController < ApplicationController
  
  before_filter :find_commentable
  
	def create
	  @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user    
    if @comment.save
      @msg = t("questions.comment_success", default: 'Thanks you for your comment.')
    else
      @msg = @comment.errors.full_messages.join("<br />")
    end  
  end
  
  protected
    def find_commentable()
      commentable_type, commentable_id = params[:comment][:commentable_type], params[:comment][:commentable_id]
      @commentable = commentable_type.constantize.find(commentable_id)      
    end
end