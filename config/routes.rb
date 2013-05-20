EnjoyTheWeb::Application.routes.draw do

  ## To accept ajax cross domain
  match '/*path' => 'application#options', :via => :options
  
  resources :feedback, :only => [:new, :create]

  resources :authentications
  
  get "pages/about"

  ## Webapp/Alveoles
  match "/webapps/:id/tags/", :to => "webapps#tags"
  match "/webapps/:id/bookmarks/", :to => "webapps#bookmarks"
  match "/webapps/trend/:type", :to => "webapps#trend"
  match "/webapps/search/:search", :to => "webapps#search"

  ## User
  match "/users/:id/bookmarks/", :to => "users#bookmarks"

  ## Categories
  match "/categories/:id/webapps", :to => "categories#webapps"
  match "/categories/:id/featured_webapp", :to => "categories#featured_webapp"
  match "/categories/:id/featured_webapps", :to => "categories#featured_webapps"
  match "/categories/featured_webapps", :to => "categories#categories_featured_webapps"

  match '/about',   :to => 'pages#about'
  match '/faq',   :to => 'pages#faq'
  match '/accueil',   :to => 'webapps#index'
  match "/contact", :to => "pages#contact"

  resources :tags do
    resources :webapps
    member do
      get 'associated'
    end
  end


  resources :comments

  resources :categories

  resources :webapps do
    resources :bookmarks  
    resources  :tags
    resources :comments
    member { post :vote }    
  end

  resources :users, :except => :destroy do
    resources :webapps do
      resources :comments
    end
  end



  namespace :admin do
    resources :users
    resources :webapps

  end
  devise_for :users, :controllers => {:sessions => 'sessions'}

  devise_scope :user do
    delete "sign_out", :to => "sessions#destroy"
    post "sign_in", :to => "sessions#create"
  end

  match '/webapps/:id/click/:element' => 'webapps#click'
  match '/auth/:provider/callback' => 'authentications#create'
  root :to => "webapps#index"



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
