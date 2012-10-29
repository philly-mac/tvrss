class ApplicationController < ActionController::Base
  protect_from_forgery

  include SimpleAuth::Helpers
  include ApplicationHelper
  # include UsersHelper

  helper_method :current_user, :logged_in?

  def user_model
    User
  end

  def authenticate_user!
    authenticate! do
      store_location_to_session
      redirect_to(root_path)
    end
  end

  def store_location_to_session
    session[:return_to_url] = request.url if request.get?
  end

  def redirect_after_authentication
    if session[:return_to_url].nil?
      redirect_to root_path
    else
      redirect_to session[:return_to_url]
      session[:return_to_url] = nil
    end
  end

end

