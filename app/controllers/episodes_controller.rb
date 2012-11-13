class EpisodesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_episode, :except => [:index, :calendar]

  def index
    @show = Show.where(:id => params[:show_id]).first
    @episodes = @show.episodes_dataset
      .order(Sequel.desc(:air_date))
      .all

    respond_to do |format|
      format.html { render :action => 'show' }
      format.rss  { render :action => 'show' }
    end
  end

  def calendar
    @from_date = Date.parse(params[:from_date])
    @to_date   = Date.parse(params[:to_date])

    @episodes = Episode
      .where(:air_date => @from_date..@to_date)
      .where(:show_id => current_user.shows.map(&:id))
      .order(Sequel.desc(:air_date))
      .all

    respond_to do |format|
      format.html { render :action => 'show' }
      format.rss  { render :action => 'show' }
    end
  end

  def watched
    unless @episode.users_dataset.where(:id => current_user.id).first
      @episode.add_user(current_user)
    end

    render :nothing => true
  end

  def unwatched
    if @episode.users_dataset.where(:id => current_user.id).first
      @episode.remove_user(current_user)
    end

    render :nothing => true
  end

private

  def load_episode
    @episode = Episode.where(:id => params[:id]).first
  end
end


