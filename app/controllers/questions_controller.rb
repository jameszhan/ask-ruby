class QuestionsController < ApplicationController

  load_and_authorize_resource :only => [:new, :edit, :create, :update, :destroy]  
 
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
    hots: {
      views_count: :desc
    },
    answers: {
      answers_count: :desc
    }
  }
   
  # GET /questions
  # GET /questions.json
  def index
=begin
    sort = params[:sort] || 'activity-desc'
    case sort
      when 'date-desc'
        order = :created_at.desc
      when 'date-asc'
        order = :created_at.asc
      when 'votes-desc'
        order = :votes_count.desc
      when 'votes-asc'
        order = :votes_count.asc
      when 'views-desc'
        order = :views_count.desc
      when 'views-asc'
        order = :views_count.asc
      when 'answers-desc'
        order = :answers_count.desc
      when 'answers-asc'
        order = :answers_count.asc
      when 'activity-asc'
        order = :updated_at.asc
    else
      order = :updated_at.desc
    end
=end
    find_questions
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    @question.viewed!(request.remote_ip)
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
    @question.user_id = current_user.id
    @question.node = current_node
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
  
  def preview
    @body = params[:body]
    respond_to do |format|
      format.json
    end
  end
  
end
