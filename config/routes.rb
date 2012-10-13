Tvrss::Application.routes.draw do

  root :to => "shows#index"

  match 'logout'   => 'sessions#destroy',  :as => :logout,   :via => :get
  match 'login'    => 'sessions#new',      :as => :login,    :via => :get
  match 'calendar' => 'episodes#calendar', :as => :calendar, :via => :get

  resources :users do
    resources :shows do
      collection do
        get :search
        get :cancelled
      end

      resources :episodes
    end
  end
end
