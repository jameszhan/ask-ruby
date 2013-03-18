class AnswersController < ApplicationController
  
  before_filter :find_question
  
  # POST /answers
  # POST /answers.json
  def create
    authorize! :create, Answer
    @answer = @question.answers.build(params[:answer])
    @answer.user = current_user
    if @answer.save
      Notification.create(source: "Answer", source_id: @answer.id, user: @question.user) if @question.user != current_user
      NotificationMailer.answer_notify_email(@answer).deliver
      @msg = t("questions.answer_success", default: 'Answer was successfully created.')
    else
      @msg = @answer.errors.full_messages.join("<br />")
    end
  end
  

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @answers }
    end
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @answer }
    end
  end

  # GET /answers/new
  # GET /answers/new.json
  def new
    @answer = Answer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @answer }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end


  # PUT /answers/1
  # PUT /answers/1.json
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to @answer.question, notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
      format.json { head :no_content }
    end
  end
  
  protected

    def find_question
      @question = Question.find(params[:question_id])
    end
end
