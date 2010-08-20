Tvrss.controllers :episodes do
  get :index, :map => '/episodes/:id' do
    @show = Show.get params[:id]
    @episodes = @show.episodes(:order => [ :air_date.desc ])
    render 'episodes/index'
  end

  get :calendar, :provides => [:html, :xml] do
    @episodes = Episode.all(
      :air_date.gte => Date.parse(params[:from_date]),
      :air_date.lte => Date.parse(params[:to_date]),
      :order => [ :air_date.desc ]
    )

    case content_type
    when :html then
      render 'episodes/index'
    when :xml then
      render 'episodes/index.rss'
    end
  end
end

