class TagsController < ApplicationController
  #load_and_authorize_resource :only => [:new, :edit, :create, :update, :destroy]  
  
  # GET /tags
  # GET /tags.json
  def index
    @tags = current_node.tags

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = current_node.tags.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new    
    authorize! :create, Tag
    @tag = current_node.tags.build    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = current_node.tags.find(params[:id])    
    authorize! :update, @tag
  end

  # POST /tags
  # POST /tags.json
  def create  
    authorize! :create, Tag
    @tag = current_node.tags.build(params[:tag])
    @tag.user_id = current_user.id    
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = current_node.tags.find(params[:id])
    authorize! :update, @tag
    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = current_node.tags.find(params[:id])
    authorize! :destroy, @tag
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
