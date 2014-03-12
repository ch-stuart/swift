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
  get 'hub/expire_flickr' => 'hub#expire_flickr'

  # match 'deploy_hook/expire_cache' => 'application#expire_cache'

  resources :pages, :products, :companies, :hub, :colors, :parts, :sizes, :testimonials, :categories

  resources :products do
    get 'order', on: :member
  end

  resources :contacts do
    get 'copy', on: :collection
  end

  # # view cart
  # http://builtbyswift.com/cart
  #
  # # purchase what's in cart/checkout
  # http://builtbyswift.com/cart/checkout
  #
  # # completed purchase
  # http://builtbyswift.com/orders/7e59b9a5-4055-46eb-944c-185051f9ebf7

  resources :sales do
    get 'success', on: :member
    get 'checkout', on: :new
  end

  get 'cart', to: 'sales#cart'
  get 'cart/checkout', to: 'sales#checkout'
  get 'orders/:guid', to: 'sales#success', as: :order

  post 'postmaster/validate', to: 'postmaster#validate'
  post 'postmaster/rates', to: 'postmaster#rates'

  match 'wa_state_taxes/rate', to: 'wa_state_taxes#rate'

  get 'logout', :to => 'application#logout'
  get 'login', :to => 'hub#index'
  get 'wholesale_login', :to => 'application#wholesale_login'

  get 'store', :to => 'homes#store'
  get "accessories" => redirect("/store")

  root :to => 'homes#index'

end
