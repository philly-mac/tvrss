class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_admin

  def index
    @shows = Show.order(:name).all
    render 'admin/index'
  end

  def new
    render :action => 'index'
  end

  def create
    @show = Show.new(params[:show])
    @show.save ? notice = 'Saved' : alert = "Error"
    redirect_to shows_path
  end

  def destroy
    if @show = Show.get(params[:id])
      @show.episodes.destroy
      @show.destroy
    end

    redirect_to shows_path
  end

  def update
    @show = Show.get(params[:id])
    @show.attributes = params[:show]
    @show.save ? notice = 'Saved' : alert = "Error"
    load_shows
    redirect_to shows_path
  end

  def search_shows
    render 'admin/search'
  end

  def find_shows
    if (@shows = Show.search_tv_rage(params[:search_term])).empty?
      flash[:alert] = "Something went wrong getting the shows data"
    end

    render 'admin/search'
  end

  def add_show
    @show = Show.new(:tvr_show_id => params[:tvr_id])
    @show.save ? notice = 'Saved' : alert = "Error"
    redirect_to admin_path
  end

  def reimport_shows
    if show = Show.where(:id => params[:id]).first
      Show.populate_fields([show])
    end

    redirect_to admin_path
  end

  def load_shows
    @shows = Show.all(:order => [ :name.asc])
  end

  def reimport_edisodes
    if show = Show.where(:id => params[:id]).first
      if Episode.import([show])
        flash[:notice] = "Successful"
      else
        flash[:alert] = "Something went wrong"
      end
    end
    redirect_to shows_path
  end

private

  def authorize_admin
    unless can? :manage, Show
      redirect root_path
      return
    end
  end
end
