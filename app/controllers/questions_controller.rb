class QuestionsController < ApplicationController  
  load_and_authorize_resource :only => [:new, :edit, :create, :update, :destroy, :follow, :unfollow, :solve, :unsolve], :through => :current_node
 
  order_tabs :index => {
    newest: {
      created_at: :desc,
    },
    votes: {
      votes_average: :desc,
      views_count: :desc
    },
    activity: {
      updated_at: :desc,
      created_at: :desc
    },
    hot: {
      views_count: :desc
    },
    answers: {
      answers_count: :desc
    }
  }, :show => {
    newest: {
      created_at: :desc,
    },
    oldest: {
      created_at: :asc,
    },
    votes: {
      votes_average: :desc,
      views_count: :desc
    }
  }
   
  # GET /questions
  # GET /questions.json
  def index
    find_questions
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = current_node.questions.find(params[:id])
    @question.viewed!(request.remote_ip)
    @answers = (@question.answers.page params[:page]).order_by(current_order)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    #@question = Question.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    #@question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    #@question = Question.new(params[:question])
    #@question.node = current_node
    @question.user_id = current_user.id
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    #@question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    #@question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
  
  def solve
    @answer = @question.answers.find(params[:answer_id])
    @question.answered_with = @answer if @question.answered_with.nil?
    @question.accepted = true
    
    if @question.save
      current_user.on_activity(:close_question, current_node)
      if current_user != @answer.user
        @answer.user.update_reputation(:answer_picked_as_solution, current_node)
      end     
    end
  end
  
  def unsolve
    @answer = @question.answers.find(params[:answer_id])
    @question.accepted = false
    @question.answered_with = nil if @question.answered_with == @answer
    
    @question.save 
  end  
  
  def follow
    if @question.followed_by?(current_user)
      @question.unfollowed_by!(current_user)
    else
      @question.followed_by!(current_user)
    end
    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end  
  
end
