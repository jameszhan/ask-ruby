class AnswersController < ApplicationController
  
  before_filter :find_question
  
  # POST /answers
  # POST /answers.json
  def create
    puts "%" * 100
    puts "current_user => #{current_user.email}"
    puts "can_answer_question => #{can? :create, Answer}"
    authorize! :create, Answer
    @answer = @question.answers.build(params[:answer])
    @answer.user = current_user
    if @answer.save
      @msg = t("questions.answer_success", default: 'Answer was successfully created.')
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
      @msg = "Update Successful."
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
      @question = Question.find(params[:question_id])
    end
end
