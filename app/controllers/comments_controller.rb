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
      #TODO Here is a hole of this method, since we depend on a order hash.
      params.each do |name, value|
        if name =~ /(.+)_id$/
          if @commentable 
            @commentable = @commentable.send($1.pluralize.to_sym).find(value)
          else
            @commentable = $1.classify.constantize.find(value)
          end          
        end
      end  
    end
end