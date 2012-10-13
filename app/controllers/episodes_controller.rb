class EpisodesController < ApplicationController

  before_filter :authenticate_user!

  load_and_authorize_resource :show, :except => [:calendar]
  load_and_authorize_resource :episode, :through => :show, :except => [:calendar]

  def show
    @show = Show.get params[:id]
    @episodes = @show.episodes(:order => [ :air_date.desc ])
    respond_to do |format|
      format.html { render :action => 'show' }
      format.rss  { render :action => 'show' }
    end
  end

  def calendar
    @from_date = Date.parse(params[:from_date])
    @to_date = Date.parse(params[:to_date])

    @episodes = Episode.all(
      :air_date.gte => @from_date,
      :air_date.lte => @to_date,
      :order => [ :air_date.desc ]
    )

    respond_to do |format|
      format.html { render :action => 'show' }
      format.rss  { render :action => 'show' }
    end
  end

  def reimport
    if Episode.import_episodes(params[:tvr_show_id])
      flash[:notice] = "Successful"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to shows_path
  end
end

