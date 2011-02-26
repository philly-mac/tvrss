class ShowsController < ApplicationController

  def index
    load_shows
    render :action => 'index'
  end

  def new
    @show = Show.new
    render :action => 'index'
  end

  def create
    @show = Show.new(params[:show])
    @show.save ? notice = 'Saved' : alert = "Error"
    redirect_to shows_path
  end

  def destroy
    @show = Show.get(params[:id])

    confirm = params[:confirm]

    if @show
      if confirm && confirm == 'true'

        @show.episodes.destroy
        @show.destroy
      else
        return render 'shows/confirm.html'
      end
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

  def search
    @searched_shows = Show.get_show_list(params[:show_name])
    render :action => 'index'
  end

  def reimport
    Show.fill_in_show_information(params[:tvr_show_id])
    redirect_to shows_path
  end

  def load_shows
    @shows = Show.all(:order => [ :name.asc])
  end
end

