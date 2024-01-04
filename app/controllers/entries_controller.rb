class EntriesController < ApplicationController
  before_action :require_admin_secret, only: [:create, :update]

  def index
    @entries = Entry.all.order(published_at: :desc)
  end

  def show
    @entry = Entry.find_by!(entry_path: params[:entry_path])
    @body_html = CommonMarker.render_html(@entry.body, [:DEFAULT, :HARDBREAKS, :UNSAFE, :FOOTNOTES], [:table]).html_safe
  end

  def new
    @entry = Entry.new
  end

  def edit
    @entry = Entry.find_by!(entry_path: params[:entry_path])
  end

  def create
    published_at = Time.zone.now
    entry_path = published_at.strftime('%Y/%m/%d/%H%M%S')

    @entry = Entry.new(
      title: params[:entry][:title].present? ? params[:entry][:title] : nil,
      body: params[:entry][:body],
      published_at:,
      entry_path:,
    )

    ActiveRecord::Base.transaction do
      @entry.save!
      redirect_to entry_entries_path(entry_path: @entry.entry_path)
    rescue ActiveRecord::RecordInvalid
      render :new
    end
  end

  def update
    entry_params = params.require(:entry).permit(:title, :body)

    @entry = Entry.find(params[:id])
    @entry.assign_attributes(entry_params)

    ActiveRecord::Base.transaction do
      @entry.save!
      redirect_to entry_entries_path(entry_path: @entry.entry_path)
    rescue ActiveRecord::RecordInvalid
      render :edit
    end
  end

  private def require_admin_secret
    if params[:incunabula_admin_secret] != ENV.fetch('INCUNABULA_ADMIN_SECRET')
      render plain: "unauthorized", status: :unauthorized
    end
  end
end
