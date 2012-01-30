class ColorSweeper < ActionController::Caching::Sweeper

    observe Color

    def after_create(color)
        expire_cache_for(color)
    end

    def after_update(color)
        expire_cache_for(color)
    end

    def after_destroy(color)
        expire_cache_for(color)
    end

    private

    def expire_cache_for(color)
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