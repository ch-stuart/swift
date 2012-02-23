# class TestimonialSweeper < ActionController::Caching::Sweeper
# 
#     observe Testimonial
# 
#     def after_create(testimonial)
#         expire_cache_for(testimonial)
#     end
# 
#     def after_update(testimonial)
#         expire_cache_for(testimonial)
#     end
# 
#     def after_destroy(testimonial)
#         expire_cache_for(testimonial)
#     end
# 
#     private
# 
#     def expire_cache_for(testimonial)
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