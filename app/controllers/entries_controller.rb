class EntriesController < ApplicationController
  def index
    @entries = Entry.all
  end

  def show
    @entry = Entry.find_by!(entry_path: params[:entry_path])
    @body_html = CommonMarker.render_html(@entry.body, :DEFAULT).html_safe
  end
end
