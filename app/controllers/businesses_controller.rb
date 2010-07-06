class BusinessesController < ApplicationController
 skip_before_filter :authorize, :only => [:index, :search]
  def index
    @businesses = Business.paginate :page => params[:page], :order => 'name ASC'
    @title = "Listing Businesses"
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @businesses }
    end
  end

  def search
    @conditions = Hash.new
    @conditions[:name] = params[:name] if params[:name] != "" and params[:name] != nil and params[:name] != "Name"
    @conditions[:city] = params[:city] if params[:city] != "" and params[:city] != nil and params[:city] != "City Name"
    @conditions[:location] = params[:location] if params[:location] != "" and params[:location] != nil and params[:location] != "Location"
    @conditions[:category] = params[:category] if params[:category] != "" and params[:category] != nil
    @conditions[:sub_category] = params[:sub_category_name] if params[:sub_category_name] != "" and params[:sub_category_name] != nil and params[:sub_category_name] != "Product/Service Category"
    p "====>>>>>>"
    p @conditions
    if @conditions != {}
      @search_results = Business.search :conditions => @conditions
      if @search_results.empty?
        @text = "No results found."
      else
        @text = "" 
      end
    else
      @text = "Enter valid parameters"
    end
  end
  
  def show
    @business = Business.find(params[:id])
    @title = "Business Details - #{@business.name}"
    #Edit and Delete for owners and Add to Favorites for those who haven't added it yet.
    @favorite = true unless is_favorite(@business)
    @owner = true if is_owner(@business)
    if @business.lat != nil and @business.lng != nil
      @map = GoogleMap::Map.new
      @map.center = GoogleMap::Point.new(@business.lat, @business.lng)
      @map.zoom = 15
      @map.markers << GoogleMap::Marker.new(  :map => @map,
                                              :lat => @business.lat,
                                              :lng => @business.lng,
                                              :html => @business.name)
    end
    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @business }
    end
  end

# def show_on_map
#  respond_to do |format|
#      format.js
#    end
#  end
  
  def new
    @title = "Add Business"
    @business = Business.new
  end

  def get_locations
    unless request.xhr?
      flash_redirect("error", "Invalid Page", root_path)
    else
      @city = City.find_by_city(params[:business_city])
      unless @city.nil?
        p "======*******>>>>>>>>"
        @locations = @city.locations 
        render :partial=> "business_location"
     else
       flash.now[:message] = "Not a valid city"
     end
    end
  end
  
  def get_sub_categories
    unless request.xhr?
      flash[:error] = "Invalid page"
      redirect_to root_path
    else
      @category = Category.find_by_category(params[:business_category])
      unless @category.nil?
        @sub_categories = @category.sub_categories
        render :partial=> "business_sub_category"
      else
        flash.now[:message] = "Not a valid category"
      end
    end
  end
    
  def locations
    @city = City.find(:first, :conditions => ['city LIKE ?', "%#{params[:city]}"])
    search_reg_exp = /(?:([a-zA-Z0-9]*[\s,]+)*)([a-zA-Z0-9]+)$/
    @search_query = params[:search][search_reg_exp,2]
    if @city != nil
      @locations = @city.locations.find(:all, 
                      :conditions => ['location LIKE ?',"%#{@search_query}%"]) 
    else
      @locations = Location.find(:all, 
                        :conditions => ['location LIKE ?',"%#{@search_query}%"])
    end
      
  end
  
  def business_names
    search_reg_exp = /(?:([a-zA-Z0-9]*[\s,]+)*)([a-zA-Z0-9]+)$/
    @search_query = params[:search][search_reg_exp,2]
    @businesses = Business.find(:all,
                        :conditions => ['name LIKE ?',"%#{@search_query}%"])
  end
    
  def edit
    @title = "Edit Business"
    @business = Business.find(params[:id])
  end

 
  def create
    @business = Business.new(params[:business])
    @business.owner = @member.full_name
    
    #@business.categories = params[:business][:category_name].collect {|category|}
    if @business.save and BusinessRelation.create(:member_id => @member.id,:business_id => @business.id, :status => RELATION[:OWNED])
     
      flash_redirect("message","Business was successfully added",businesses_path)
    else
      @business.destroy
      render  :action => :new
    end
  end

  def update
    @business = Business.find(params[:id])
    #### Allow only if the user owns the business
    if is_owner(@business) 
      if @business.update_attributes(params[:business])
        flash_redirect("message","Business was successfully added",business_path(params[:id]))
      else
        render :action => :edit
      end
    else
      flash_redirect("notice", "Nice try", member_path(@member.id))
    end 
  end

 
  def destroy
    @business = Business.find(params[:id])
    if is_owner(@business) 
      if @business.destroy
        flash_redirect("message","Business was successfully deleted",member_path(@member.id))
      else
        redirect_to business_path(@business.id)
      end
    else
      flash_redirect("notice","You can delete your own business",member_path(@member.id))
    end
  end
  
  def add_favorite
    @business = Business.find_by_id(params[:id])
    #Adding same business twice in the list is not allowed
    if is_favorite(@business) 
      flash_redirect("notice", "Business already in your list", session[:return_to])
    else
      if BusinessRelation.create(:member_id => @member.id, :business_id => @business.id, :status => RELATION[:FAVORITE])
        respond_to do |format|
          format.js 
        end
      else
        flash_redirect("notice","Unable to add business to your list. Try again.",session[:return_to])
      end
    end
  end
  
  def remove_favorite
    @business = Business.find_by_id(params[:id])
    #Cannot remove business if it is not in favorite
    if !is_favorite(@business)
      flash_redirect("notice","Business not in your list",session[:return_to])
    else
      if BusinessRelation.destroy(@business_relation.id)
        respond_to do |format|
          format.js 
        end
      else
        flash_redirect("notice","Unable to remove from list. Please try again.",session[:return_to])
      end
    end
  end
  
  protected
    
    #Checks whether the person is owner or not.
    def is_owner(business)
      if business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",@member.id,RELATION[:OWNED]])
        return true
      else
        return false
      end
    end
    
    #checks whether the person has added the business as favorite.
     def is_favorite(business)
      if @business_relation = business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",@member.id,RELATION[:FAVORITE]])
        return true
      else
        return false
      end
    end
    
    
end
