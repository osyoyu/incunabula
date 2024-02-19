class ImagesController < ApplicationController
  before_action :require_admin, only: [:create]

  def show
    @image = Image.find(params[:id])
    @embed_tag = <<~__EOS__
    <div style="font-size: 14px; text-align: center;">
    <a href="#{@image.public_url}"><img src="#{@image.public_url(width: 480)}" style="max-width: min(480px, 90%); border: 1px solid #000;" /></a><br />
    (caption)
    </div>
    __EOS__
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
