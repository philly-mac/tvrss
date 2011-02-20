cred_file = "#{Rails.root}/config/credentials"
require cred_file if File.exists?(cred_file)

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticated?, :except => [:index, :authenticate]


  def index
    if logged_in?
      redirect_to shows_path
    else
      render '/site/index'
    end
  end

  def authenticated?
    return true if logged_in?
    redirect_to root_path
  end

  def authenticate
    username = defined?(USERNAME) ? USERNAME : 'username'
    password = defined?(PASSWORD) ? PASSWORD : 'password'
    login(params[:username] == username && params[:password] == password)
    if logged_in?
      redirect_to shows_path
    else
      render :action => 'index'
    end
  end

  def login(status)
    session[:logged_in] = status
  end

  def logged_in?
    session[:logged_in]
  end
  helper_method :logged_in?

  def logout
    session.delete(:logged_in)
    redirect_to root_path
  end

end
