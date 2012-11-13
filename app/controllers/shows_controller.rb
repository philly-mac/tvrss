class ShowsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_show, :except => [:search]

  def index
    @shows = current_user.shows
  end

  def add
    current_user.add_show(@show)
    redirect_to shows_path
  end

  def watched
    @show.episodes.each do |episode|
      unless episode.users_dataset.where(:id => current_user.id).first
        episode.add_user(current_user)
      end
    end

    redirect_to shows_path
  end

  def search
    @searched_shows = Show.search_db(params[:show_name])
    render :action => 'index'
  end

  def cancelled
    @shows = Show.cancelled
    render :action => 'index'
  end

private

  def load_show
    @show = Show.where(:id => params[:id]).first
  end
end

