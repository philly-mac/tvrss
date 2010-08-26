class Tvrss < Padrino::Application
  enable  :sessions
  use Rack::Flash

  register Padrino::Mailer
  register Padrino::Helpers
  register SassInitializer

  def excluded_paths
    {
      '/authenticate' => [:post, :get],
    }
  end

  def path_excluded?
    if excluded_paths.has_key?(request.path)
      return excluded_paths[request.path].include?(request.env['REQUEST_METHOD'].downcase.to_sym)
    end

    false
  end

  before do
    unless path_excluded?
      unless session[:logged_in]
        redirect '/authenticate'
      end
    end
  end

  get :authenticate do
    render '/authentication/login.html'
  end

  post :authenticate do
    session[:logged_in] = (params[:username] == 'username' && params[:password] == 'password')
    redirect url_for(:shows, :index)
  end

  get :logout do
    session.delete(:logged_in)
    redirect '/authenticate'
  end

  get :index do
    redirect url_for(:shows, :index)
  end
end
