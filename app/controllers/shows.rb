Tvrss.controllers :shows do
  get :index do
    @shows = Show.all
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
    @show = Show.first(params[:id])

    if @show
      @show.destroy
    end

    redirect url_for(:shows, :index)
  end
end