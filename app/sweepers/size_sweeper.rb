class SizeSweeper < ActionController::Caching::Sweeper

    observe Size

    def after_create(size)
        expire_cache_for(size)
    end

    def after_update(size)
        expire_cache_for(size)
    end

    def after_destroy(size)
        expire_cache_for(size)
    end

    private

    def expire_cache_for(size)
      expire_action :controller => 'homes', :action => 'index'
      expire_action :controller => 'homes', :action => 'accessories'

      Product.all.each do |product|
          expire_action :controller => 'products', :action => 'show', :id => product.id
          expire_action :controller => 'products', :action => 'order', :id => product.id
      end
      Page.all.each do |page|
          expire_action :controller => 'pages', :action => 'show', :id => page.id
      end
    end

end