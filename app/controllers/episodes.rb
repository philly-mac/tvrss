Tvrss.controllers :episodes do
  get :index, :map => '/episodes/:id' do
    render 'episodes/index'
  end
end