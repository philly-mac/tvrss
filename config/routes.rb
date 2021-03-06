Tvrss::Application.routes.draw do

  root :to => 'shows#index'

  # Sessions
  resources :sessions, :only => [:index, :new, :create, :destroy]

  match 'logout'   => 'sessions#destroy',  :as => :logout,   :via => :get
  match 'login'    => 'sessions#new',      :as => :login,    :via => :get
  match 'calendar' => 'episodes#calendar', :as => :calendar, :via => :get

  get  'admin/'                  => 'admin#index'
  get  'admin/shows/reimport'    => 'admin#reimport_shows'
  get  'admin/shows/find'        => 'admin#find_shows'
  get  'admin/shows/search'      => 'admin#search_shows'
  post 'admin/shows/add'         => 'admin#add_show'
  get  'admin/episodes/reimport' => 'admin#reimport_episodes'

  resources :shows do

    member do
      post :add
      put  :watched
    end

    collection do
      get :search
      get :cancelled
    end

    resources :episodes do
      member do
        put  :watched
        put  :unwatched
      end
    end
  end
end
