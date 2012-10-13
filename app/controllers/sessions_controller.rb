class SessionsController < ApplicationController

  before_filter :authenticate_user!, :only => :destroy

  def index
    flash.keep
    if logged_in?
      redirect_to "shows#index"
    else
      render 'new'
    end
  end

  def new
    render 'new'
  end

  def create
    if user = User.authenticate((params[:email] || params[:user]), params[:password])
      if user.active?
        self.current_user = user
        flash[:notice] = "session.authenticated_message".t
        redirect_after_authentication
      else
        flash.now[:alert] = "registration.unconfirmed_message".t
        render 'new'
      end
    else
      flash.now[:alert] = "session.unauthenticated_message".t
      render 'new'
    end
  end

  def destroy
    log_out!
    redirect_to new_session_path, :notice => "You have been logged out"
  end

end

