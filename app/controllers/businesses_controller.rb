class BusinessesController < ApplicationController
 
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
    p params[:name]
    if params[:name] != "" and params[:name] != nil 
      p "======>>>>>>>>"
      @conditions[:name] = params[:name] 
    end
    if params[:city] != "" and params[:city] != nil
       @conditions[:city] = params[:city]
    end
    if params[:location] != "" and params[:location] != nil
      @conditions[:location] = params[:location] 
    end
    @search_results = Business.search :conditions => @conditions
    if @search_results.empty?
      @text = "No results found."
    else
      @text = "#{@search_results.size} results found."
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
    @cities = City.find(:all)
    @business = Business.new
  end

  def get_locations
    unless request.xhr?
    flash_redirect("error", "Invalid Page", root_path)
    else
    @locations = City.find_by_city(params[:business_city]).locations
    render :partial=> "business_location"
    end
  end
  
  def get_sub_categories
    unless request.xhr?
    flash[:error] = "Invalid page"
    redirect_to root_path
    else
    @sub_categories = Category.find_by_category(params[:business_category]).sub_categories
    render :partial=> "business_sub_category"
    end
  end
    
  def edit
    @title = "Edit Business"
    @business = Business.find(params[:id])
  end

 
  def create
    @business = Business.new(params[:business])
    @business.owner = @member.first_name + " " + @member.last_name
    if @business.save and BusinessRelation.create(:member_id => @member.id,:business_id => @business.id, :status => RELATION[:OWNED])
      flash_redirect("message","Business was successfully added",businesses_path)
    else
      @business.destroy
      render  :action => :new
    end
  end

  def update
    if request.put?
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
