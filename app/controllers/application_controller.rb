class ApplicationController < ActionController::Base
  def require_admin
    if params[:incunabula_admin_secret] != Rails.configuration.x.admin_secret
      render plain: "unauthorized", status: :unauthorized
    end
  end
end
