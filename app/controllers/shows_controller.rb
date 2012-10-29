class ShowsController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource :show, :except => [:search]

  def index
  end

  def search
    @searched_shows = Show.get_show_list(params[:show_name])
    render :action => 'index'
  end

  def cancelled
    @shows = Show.cancelled
    render :action => 'index'
  end
end

