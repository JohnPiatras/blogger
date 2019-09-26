Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'articles#index'
  resources :articles do
    resources :comments
  end
  resources :tags
  resources :authors

  get 'popular' => 'articles#show_popular'
  get 'month/:month' => 'articles#show_month', as: :month
  get 'rss_feed' => 'articles#index', :as => :rss_feed, :defaults => { :format => 'rss'}

  resources :author_sessions, only: [ :new, :create, :destroy ]

  # here's how we define routes
  get 'login' => 'author_sessions#new'
  get 'logout' => 'author_sessions#destroy'
  #so for example if we have a popular articles show method we could use this to create the route:
  #get 'popular' => 'article#show_popular'
end
