Tvrss::Application.routes.draw do

  root :to => "application#index"

  match 'authenticate' => 'application#authenticate', :via => :post
  match 'logout'       => 'application#logout',       :via => :get
  match 'calendar'     => 'episodes#calendar',        :via => :get

  resources :shows do
    collection do
      get :reimport
      get :search
    end

    member do
      get :reimport
    end
  end

  resources :episodes do
    collection do
      get :reimport
    end

    member do
      get :reimport
    end
  end

end
