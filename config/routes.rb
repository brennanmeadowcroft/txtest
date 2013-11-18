TextTests::Application.routes.draw do
  scope '/admin' do
    resources :plans
    resources :events, :only => [:index, :show, :create]
  end
  resources :charges
  resources :users
  resources :courses
  resources :answers, :only => [:new, :edit, :create, :update, :destroy]
  resources :questions, :only => [:show, :edit, :new, :create, :update, :destroy]
  resources :settings, :only => [:edit, :update]
  resources :sessions, :only => [:new, :create, :destroy ]

  match '/admin' => 'users#index', :as => :admin_root
  match '/courses' => 'courses#index', :as => :user_root

  match '/signin' => 'sessions#new', :as => :signin
  match '/signout', to: 'sessions#destroy'
  match '/signup' => 'users#new', :as => :signup

  match '/answers/:id/mark_correct' => 'answers#mark_correct', :as => :mark_correct
  match '/answers/:id/text_receipt' => 'answers#text_receipt', :via => :post
  match '/sms/receive' => 'sms#receive', :via => :post
  match '/courses/:id/pause' => 'courses#pause', :as => :pause_course
  match '/questions/:id/pause' => 'questions#pause', :as => :pause_question
  match '/users/:id/account' => 'users#account', :as => :account
  match '/users/:id/account/edit' => 'users#edit_account', :as => :edit_account
  match '/users/:id/toggle_admin' => 'users#toggle_admin', :as => :toggle_admin

  match '/' => 'static_page#index', :as => :public_root
  match '/faq' => 'static_page#faq', :as => :faq
  match '/privacy_policy' => 'static_page#privacy_policy', :as => :privacy_policy
  match '/terms_of_service' => 'static_page#terms_of_service', :as => :terms_of_service
  match '/pricing' => 'static_page#pricing', :as => :pricing
  match '/courses' => 'courses#index', :as => :app_root

  root :to => 'static_page#index'

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
