class AnswersController < ApplicationController
  
  before_filter :find_question
  
  # POST /answers
  # POST /answers.json
  def create
    authorize! :create, Answer
    @answer = @question.answers.build(params[:answer])
    @answer.user = current_user
    if @answer.save
      @msg = t("alert.answer.create_success", default: 'Answer was successfully created.')
    else
      @msg = @answer.errors.full_messages.join("<br />")
    end
  end
  
  # PUT /answers/1
  # PUT /answers/1.json
  def update
    @answer = @question.answers.find(params[:id])
    authorize! :update, @answer
    
    if @answer.update_attributes(params[:answer])
      @msg = t("alert.answer.update_success", default: 'Update Successful.')
    else
      @msg = @error = @answer.errors.full_messages.join("<br />")
    end   
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = @question.answers.find(params[:id])
    authorize! :destroy, @answer
    @answer.destroy
    
    head :no_content
  end
  
  protected

    def find_question
      @question = current_node.questions.find(params[:question_id])
    end
end
