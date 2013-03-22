class TagsController < ApplicationController
  #load_and_authorize_resource :only => [:new, :edit, :create, :update, :destroy]  
  respond_to :html, :json
  
  # GET /tags
  # GET /tags.json
  def index
    @tags = current_node.tags
    respond_with @tag
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = current_node.tags.find(params[:id])
    respond_with @tag
  end

  # GET /tags/new
  # GET /tags/new.json
  def new    
    authorize! :create, Tag
    @tag = current_node.tags.build    
    respond_with @tag
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
    
    flash[:notice] = "Tag was successfully created." if @tag.save
    respond_with @tag    
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = current_node.tags.find(params[:id])
    authorize! :update, @tag
    
    flash[:notice] = "Tag was successfully updated." if @tag.update_attributes(params[:tag])
    respond_with @tag 
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = current_node.tags.find(params[:id])
    authorize! :destroy, @tag
    @tag.destroy
    
    respond_with(@user) do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
