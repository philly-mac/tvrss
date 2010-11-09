Tvrss.controllers :episodes do
  get :index, :map => '/episodes/:id' do
    @show = Show.get params[:id]
    @episodes = @show.episodes(:order => [ :air_date.desc ])
    render 'episodes/index.rss'
  end

  get :calendar do
    @from_date = Date.parse(params[:from_date])
    @to_date = Date.parse(params[:to_date])

    @episodes = Episode.all(
      :air_date.gte => @from_date,
      :air_date.lte => @to_date,
      :order => [ :air_date.desc ]
    )

    render 'episodes/index.rss'
  end

  get :reimport_episodes do
    Episode.import_episodes(true, params[:tvr_show_id])
    redirect url_for(:shows, :index)
  end
end

