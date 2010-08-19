Tvrss.controllers :shows do
  get :index do
    @shows = Show.all(:order => [ :name.asc])
    render 'shows/index'
  end

  get :new do
    @show = Show.new
    render 'shows/new'
  end

  post :create do
    @show = Show.new(params[:show])

    if @show.save
      redirect url_for(:shows, :index)
    else
      render 'shows/new'
    end
  end

  delete :destroy, :with => :id do
    @show = Show.get(params[:id])

    if @show
      @show.episodes.destroy
      @show.destroy
    end

    redirect url_for(:shows, :index)
  end

  get :search do
    @searched_shows = Show.get_show_list(params[:show_name])
    render 'shows/index'
  end
end

