ActionController::Routing::Routes.draw do |map|
  map.resources :orders

  

  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  
  #NAMED ROUTES
  map.root :controller => "members"
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'delete'
  map.admin '/admin', :controller => "admin/admin", :action => :index
  map.admin_members "/admin/members", :controller => "admin/members", :action => :index
  map.admin_businesses "/admin/businesses", :controller => "admin/businesses", :action => :index
  map.admin_locations "/admin/locations", :controller => "admin/locations", :action => :index
  map.admin_cities "/admin/cities", :controller => "admin/cities", :action => :index
  map.admin_categories "/admin/categories", :controller => "admin/categories", :action => :index
  map.admin_subcategories "/admin/subcategories", :controller => "admin/sub_categories", :action => :index
  map.admin_orders "/admin/orders", :controller => "admin/orders", :action => :index
  map.admin_order_transactions "/admin/order_transactions", :controller => "admin/order_transactions", :action => :index
  
  map.get_cities "/get_cities", :controller => "autocomplete", :action => "city"
  map.get_locations "/get_locations", :controller => "autocomplete", :action => "location"
  map.get_sub_categories "/get_sub_categories", :controller => "autocomplete", :action => "sub_category"
  map.get_names_and_categories "/get/names_and_categories", :controller => "autocomplete", :action => "names_and_categories"

  #RESOURCES
  map.resources :members, :member => {:update_password => [:post], :show_list => [:get], :show_my_businesses => [:get] }, :collection => {:forgot_password => [:get,:post] } do |members|
                                  
    members.resources :businesses, :except => [:index, :show]
  end
  
  map.resources :businesses,:only => [:index, :show], :member => { :add_favorite => [:get], :remove_favorite => [:delete], :send_to_phone => [:post] } do |members|
      members.resources :orders, :only => [:new,:create]
  end
                        

  map.resources :search, :only => [:index], :collection => [:show_on_map]
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
