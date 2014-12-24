SwiftSite::Application.routes.draw do

  # http://blog.bignerdranch.com/1666-redirect-www-subdomain-to-your-apex-domain-using-the-rails-router/
  # Remove the www from the URL, e.g. don't allow that stupid subdomain.
  # Why? It causes issues with caching, namely clearing the action cache (memcache) while
  # on builtbyswift.com does NOT clear the action cache for www.builtybyswift.com. This causes
  # the two "sites" to be out of sync and nobody likes that. cstuart 2013-02-13
  # CHANGED this is disabled because we are now going to use rack rewrite to force WWW rather
  # than the bare domain. this is because heroku sounds like it does not play nicely when you
  # set up SSL to point at the bare domain (builtbyswift.com with no www)
  # constraints(host: /^www\./i) do
  #   match '(*any)' => redirect { |params, request|
  #     URI.parse(request.url).tap { |uri| uri.host.sub!(/^www\./i, '') }.to_s
  #   }
  # end

  get 'hub' => 'hub#index'
  get 'hub/expire_flickr_cache' => 'hub#expire_flickr_cache'
  get 'hub/expire_home_cache' => 'hub#expire_home_cache'

  devise_for :users
  resources :users, only: [:index, :edit, :update, :destroy]
  get '/users/my_info', to: 'users#my_info', as: 'my_info'
  get '/users/edit_my_info', to: 'users#edit_my_info', as: 'edit_my_info'

  get 'pages/new' => 'pages#new'
  get 'pages/:path' => 'pages#show', :constraints => { :path => /[A-Za-z_-]+/ }

  resources :pages, :products, :companies, :colors, :parts, :sizes, :testimonials, :categories, :pre_approved_dealers, :coupons, :gift_certificates

  resources :products do
    get 'order', on: :member
  end

  resources :coupons do
    get 'valid', on: :member, :constraints => { :id => /[A-Za-z0-9_-]+/ }
  end

  resources :contacts do
    get 'copy', on: :collection
  end

  # # view cart
  # https://www.builtbyswift.com/cart
  #
  # # purchase what's in cart/checkout
  # https://www.builtbyswift.com/cart/checkout
  #
  # # completed purchase
  # https://www.builtbyswift.com/orders/7e59b9a5

  resources :sales do
    get 'success', on: :member
    get 'ready_for_pickup', on: :member
    get 'checkout', on: :new
    post 'charge', on: :collection
    post 'coupon', on: :collection
  end

  get 'cart', to: 'sales#cart'
  get 'cart/checkout', to: 'sales#checkout'
  get 'orders', to: 'sales#history'
  get 'orders/:guid', to: 'sales#success', as: :order

  post 'postmaster/validate', to: 'postmaster#validate'
  post 'postmaster/rates', to: 'postmaster#rates'
  post 'postmaster/fit', to: 'postmaster#fit'
  get  'postmaster/edit_shipment', to: 'postmaster#edit_shipment'
  post 'postmaster/create_shipment', to: 'postmaster#create_shipment'
  get  'postmaster/boxes', to: 'postmaster#boxes'
  post 'postmaster/create_box', to: 'postmaster#create_box'

  match 'wa_state_taxes/rate', to: 'wa_state_taxes#rate'

  get 'store', :to => 'homes#store'
  get "accessories" => redirect("/store")

  post 'exceptions/report', to: 'exceptions#report'

  root :to => 'homes#index'
end
