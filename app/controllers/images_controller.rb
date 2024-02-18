class ImagesController < ApplicationController
  before_action :require_admin, only: [:create]

  def show
    @image = Image.find(params[:id])
  end

  def new
  end

  def create
    @image = Image.from_uploaded_file(params[:file])
    Image.strip_exif!(params[:file].path)
    @image.upload_to_s3(params[:file].read)

    ActiveRecord::Base.transaction do
      @image.save!
    end

    redirect_to image_path(@image)
  rescue ActiveRecord::RecordInvalid
    render :new, status: 422
  end
end
