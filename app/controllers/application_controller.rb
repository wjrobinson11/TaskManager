class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |e|
  	render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
  end

  protected

  def after_sign_in_path_for(resource)
    tasks_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
