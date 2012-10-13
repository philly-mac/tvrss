class AdminController < ApplicationController

  before_filter :authenticate_user!

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

  def reimport_show
    Show.fill_in_show_information(params[:tvr_show_id])
    redirect_to shows_path
  end

  def load_shows
    @shows = Show.all(:order => [ :name.asc])
  end


  def reimport_edisode
    if Episode.import_episodes(params[:tvr_show_id])
      flash[:notice] = "Successful"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to shows_path
  end
end
