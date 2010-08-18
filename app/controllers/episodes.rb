Tvrss.controllers :episodes do
  get :index, :map => '/episodes/:id' do
    puts "ID IS #{params[:id]}"
    @show = Show.get params[:id]
    @episodes = @show.episodes(:order => [ :air_date.desc ])
    render 'episodes/index'
  end

  get :calendar do
    @episodes = Episode.all(
      :air_date.gte => Date.parse(params[:from_date]),
      :air_date.lte => Date.parse(params[:to_date]),
      :order => [ :air_date.desc ]
    )

    render 'episodes/index'
  end
end

