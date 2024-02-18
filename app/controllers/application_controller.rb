class ApplicationController < ActionController::Base
  def require_admin
    if params[:incunabula_admin_secret] != ENV.fetch('INCUNABULA_ADMIN_SECRET')
      render plain: "unauthorized", status: :unauthorized
    end
  end
end
