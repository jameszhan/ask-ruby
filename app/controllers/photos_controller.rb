class PhotosController < ApplicationController
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.user = current_user
    
    @photo.save!    
    render json: @photo
  end
  
end
