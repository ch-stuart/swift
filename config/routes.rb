SwiftSite::Application.routes.draw do

  # http://blog.bignerdranch.com/1666-redirect-www-subdomain-to-your-apex-domain-using-the-rails-router/
  # Remove the www from the URL, e.g. don't allow that stupid subdomain.
  # Why? It causes issues with caching, namely clearing the action cache (memcache) while
  # on builtbyswift.com does NOT clear the action cache for www.builtybyswift.com. This causes
  # the two "sites" to be out of sync and nobody likes that. cstuart 2013-02-13
  constraints(host: /^www\./i) do
    match '(*any)' => redirect { |params, request|
      URI.parse(request.url).tap { |uri| uri.host.sub!(/^www\./i, '') }.to_s
    }
  end  
    
  get 'pages/new' => 'pages#new'
  get 'pages/:path' => 'pages#show', :constraints => { :path => /[A-Za-z_-]+/ }

  get 'hub/expire_home' => 'hub#expire_home'

  # match 'deploy_hook/expire_cache' => 'application#expire_cache'

  resources :pages, :products, :companies, :hub, :colors, :parts, :sizes, :testimonials, :categories

  resources :products do
    member do
      get 'order'
    end
  end

  match 'logout', :to => 'application#logout'
  match 'login', :to => 'hub#index'

  root :to => 'homes#index'
  match 'store', :to => 'homes#store'
  match "accessories" => redirect("/store")

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

end
