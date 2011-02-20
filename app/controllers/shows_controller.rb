class ShowsController < ApplicationController

  def index
    @shows = Show.all(:order => [ :name.asc])
    render :action => 'index'
  end

  def new
    @show = Show.new
    render :action => 'index'
  end

  def create
    @show = Show.new(params[:show])

    if @show.save
      redirect_to shows_path
    else
      alert = "Error"
    end

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

  def search
    @searched_shows = Show.get_show_list(params[:show_name])
    render :action => 'index'
  end

  def reimport
    Show.fill_in_show_information(params[:tvr_show_id])
    redirect_to shows_path
  end
end

