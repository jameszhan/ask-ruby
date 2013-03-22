class CommentsController < ApplicationController
  
  before_filter :find_commentable
  
  def create    
    @comment = @commentable.comments.build(params[:comment])
  	if can? :create, Comment
      @comment.user = current_user    
      if @comment.save
        send_notication(@comment, @commentable.user)        
        @msg = t("questions.comment_success", default: 'Thanks you for your comment.')
      else
        @msg = @comment.errors.full_messages.join("<br />")
      end  
    else
      @comment.errors.add :user, "You need login to comment the message.";
      @msg = "You need login to comment the message."
    end
  end
  
  def destroy
    @comment = @commentable.comments.find(params[:id])
    if can? :destroy, @comment
      @comment.destroy    
      head :no_content
    else
      @msg = @error = "You can't delete this comment which is not belongs to you."
    end
  end
  
  
  protected
    def find_commentable()
      @commentable = find_resource_by_nested_path
    end
end