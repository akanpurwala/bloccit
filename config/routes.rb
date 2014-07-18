Bloccit::Application.routes.draw do

  devise_for :users do
    delete 'logout' => 'sessions#destroy', :as => :destroy_user_session
  end

  resources :topics do
    resources :posts, except: [:index]
  end
  
  match "about" => 'welcome#about', via: :get
    
  root :to => 'welcome#index'
end
