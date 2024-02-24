Rails.application.routes.draw do
  get 'comments/end'
  root 'home#index'

  # get "/root", to: 'controller#method',
  # get '/root', to: 'home#index', as: :root

  # account access
  get '/sign_in', to: 'sign_in#index', as: :signin
  get '/register', to: 'register#index', as: :register
  get '/account', to: 'account#index', as: :account
  resources :subscribers, only: [:create]

  get '/about', to: 'about#index', as: :about

  # pricing
  get '/pricing', to: 'pricing#index', as: :pricing
  get '/checkout', to: 'checkout#index', as: :checkout

  get '/contact', to: 'contact#index', as: :contact

  # blog
  resources :articles do
    resources :comments, only: %i[create destroy edit update]
  end
end
# Expands into the routes below
# GET /articles mapped to articles#index # lists all of the articles
# GET /articles/new mapped to articles#new # sends you to the view that creates a new article, renders empty form
# POST /articles mapped to articles#create # where the new view sends its data to create a new article / backend /
# adds data / creates new informatio / creates a new article
# GET /articles/:id mapped to articles#show # shows you a specific article with a specific id
# GET /articles/:id/edit mapped to articles#edit # change a specific article with a specific id, renders written form
# PATCH/PUT /articles/:id mapped to articles#update # takes the request PATCH/PUT and edits the article
# DELETE /articles/:id mapped to articles#destroy # Deletes a specific article by its article id
