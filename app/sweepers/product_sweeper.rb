# class ProductSweeper < ActionController::Caching::Sweeper
# 
#     observe Product
# 
#     def after_create(product)
#         expire_cache_for(product)
#     end
# 
#     def after_update(product)
#         expire_cache_for(product)
#     end
# 
#     def after_destroy(product)
#         expire_cache_for(product)
#     end
# 
#     private
# 
#     def expire_cache_for(product)
#       expire_action :controller => 'homes', :action => 'index'
#       expire_action :controller => 'homes', :action => 'accessories'
# 
#       Product.all.each do |product|
#           expire_action :controller => 'products', :action => 'show', :id => product.id
#           expire_action :controller => 'products', :action => 'order', :id => product.id
#       end
#       Page.all.each do |page|
#           expire_action :controller => 'pages', :action => 'show', :id => page.id
#       end
#     end
# 
# end