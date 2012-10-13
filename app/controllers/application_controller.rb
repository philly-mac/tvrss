class ApplicationController < ActionController::Base
  protect_from_forgery

  include SimpleAuth::Helpers
  include ApplicationHelper
  include UsersHelper

  helper_method :current_user, :logged_in?

  def user_model
    User
  end

end

