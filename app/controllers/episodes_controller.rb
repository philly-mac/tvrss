class EpisodesController < ApplicationController

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
    Episode.import_episodes(true, params[:tvr_show_id])
    redirect_to shows_path
  end
end

